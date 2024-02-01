defmodule Mix.Utils.StaleCompatible do
  @moduledoc false

  # This module was written to deal with the incompatibilies between Elixir <= 1.9
  # and the release of Elixir 1.10. It is expected to eventually go away if certain
  # private APIs in Elixir become public or we shift away from reliance on
  # the private APIs.

  require Mix.Compilers.Elixir, as: CE

  import Record

  alias Mix.Utils.Stale

  defrecordp :source,
    source: nil,
    compile_references: [],
    runtime_references: [],
    external: []

  def parallel_require_callbacks(pid, cwd),
    do:
      parse_version()
      |> parallel_require_callbacks(pid, cwd)

  def tests_with_changed_references(test_sources),
    do:
      parse_version()
      |> tests_with_changed_references(test_sources)

  ## Test changed dependency resolution

  cond do
    Version.match?(System.version(), "< 1.16.0") ->
      def tests_with_changed_references(%Version{major: 1, minor: minor} = version, test_sources)
          when minor >= 10 and minor < 16 do
        test_manifest = Stale.manifest()
        [elixir_manifest] = Mix.Tasks.Compile.Elixir.manifests()

        if Mix.Utils.stale?([elixir_manifest], [test_manifest]) do
          compile_path = Mix.Project.compile_path()
          {elixir_modules, elixir_sources} = apply(CE, :read_manifest, [elixir_manifest])

          stale_modules =
            for CE.module(module: module) <- elixir_modules,
                beam = Path.join(compile_path, Atom.to_string(module) <> ".beam"),
                Mix.Utils.stale?([beam], [test_manifest]),
                do: module,
                into: MapSet.new()

          stale_modules =
            find_all_dependent_on(version, stale_modules, elixir_sources, elixir_modules)

          for module <- stale_modules,
              source(source: source, runtime_references: r, compile_references: c) <-
                test_sources,
              module in r or module in c,
              do: source,
              into: MapSet.new()
        else
          MapSet.new()
        end
      end

    true ->
      def tests_with_changed_references(%Version{major: 1} = version, test_sources) do
        test_manifest = Stale.manifest()
        [elixir_manifest] = Mix.Tasks.Compile.Elixir.manifests()

        if Mix.Utils.stale?([elixir_manifest], [test_manifest]) do
          compile_path = Mix.Project.compile_path()
          {elixir_modules, elixir_sources} = apply(CE, :read_manifest, [elixir_manifest])

          stale_modules =
            for {module, _} <- elixir_modules,
                beam = Path.join(compile_path, Atom.to_string(module) <> ".beam"),
                Mix.Utils.stale?([beam], [test_manifest]),
                do: module,
                into: MapSet.new()

          stale_modules =
            find_all_dependent_on(version, stale_modules, elixir_sources, elixir_modules)

          for module <- stale_modules,
              source(source: source, runtime_references: r, compile_references: c) <-
                test_sources,
              module in r or module in c,
              do: source,
              into: MapSet.new()
        else
          MapSet.new()
        end
      end
  end

  ## ParallelRequire callback: Handled differently depending on Elixir version
  def parallel_require_callbacks(%Version{major: 1, minor: minor} = version, pid, cwd)
      when minor >= 9,
      do: [
        each_module: &each_module(version, pid, cwd, &1, &2, &3),
        each_file: &each_file(version, pid, cwd, &1, &2)
      ]

  def parallel_require_callbacks(%Version{major: 1, minor: minor} = version, pid, cwd)
      when minor >= 6 and minor < 9 do
    [each_module: &each_module(version, pid, cwd, &1, &2, &3)]
  end

  def parallel_require_callbacks(_, _, _),
    do: {:error, "Your version of Elixir #{System.version()} cannot support the stale feature"}

  defp each_module(%Version{major: 1, minor: minor}, pid, cwd, file, module, _binary)
       when minor >= 9 do
    external = get_external_resources(module, cwd)

    if external != [] do
      Agent.update(pid, fn sources ->
        file = Path.relative_to(file, cwd)
        {source, sources} = List.keytake(sources, file, source(:source))
        [source(source, external: external ++ source(source, :external)) | sources]
      end)
    end

    :ok
  end

  defp each_module(%Version{major: 1, minor: minor}, pid, cwd, source, module, _binary)
       when minor >= 6 and minor < 9 do
    {compile_references, struct_references, runtime_references} =
      apply(Kernel.LexicalTracker, :remote_references, [module])

    external = get_external_resources(module, cwd)
    source = Path.relative_to(source, cwd)

    Agent.cast(pid, fn sources ->
      external =
        case List.keyfind(sources, source, source(:source)) do
          source(external: old_external) -> external ++ old_external
          nil -> external
        end

      new_source =
        source(
          source: source,
          compile_references: compile_references ++ struct_references,
          runtime_references: runtime_references,
          external: external
        )

      List.keystore(sources, source, source(:source), new_source)
    end)
  end

  defp each_file(%Version{major: 1, minor: minor}, pid, _cwd, file, lexical) when minor >= 10 do
    Agent.update(pid, fn sources ->
      case List.keytake(sources, file, source(:source)) do
        {source, sources} ->
          {compile_references, struct_references, runtime_references, _compile_env} =
            apply(Kernel.LexicalTracker, :references, [lexical])

          source =
            source(
              source,
              compile_references: compile_references ++ struct_references,
              runtime_references: runtime_references
            )

          [source | sources]

        nil ->
          sources
      end
    end)
  end

  defp each_file(%Version{major: 1, minor: 9}, pid, _cwd, file, lexical) do
    Agent.update(pid, fn sources ->
      case List.keytake(sources, file, source(:source)) do
        {source, sources} ->
          {compile_references, struct_references, runtime_references} =
            apply(Kernel.LexicalTracker, :remote_references, [lexical])

          source =
            source(
              source,
              compile_references: compile_references ++ struct_references,
              runtime_references: runtime_references
            )

          [source | sources]

        nil ->
          sources
      end
    end)
  end

  defp get_external_resources(module, cwd) do
    for file <- Module.get_attribute(module, :external_resource),
        do: Path.relative_to(file, cwd)
  end

  defp find_all_dependent_on(
         version,
         modules,
         sources,
         all_modules,
         resolved \\ MapSet.new()
       ) do
    new_modules =
      for module <- modules,
          module not in resolved,
          dependent_module <- dependent_modules(version, module, all_modules, sources),
          do: dependent_module,
          into: modules

    if MapSet.size(new_modules) == MapSet.size(modules) do
      new_modules
    else
      find_all_dependent_on(version, new_modules, sources, all_modules, modules)
    end
  end

  cond do
    Version.match?(System.version(), "< 1.16.0") ->
      defp dependent_modules(%Version{major: 1, minor: minor}, module, modules, sources)
           when minor >= 11 do
        for CE.source(
              source: source,
              runtime_references: r,
              compile_references: c,
              export_references: s
            ) <- sources,
            module in r or module in c or module in s,
            CE.module(sources: sources, module: dependent_module) <- modules,
            source in sources,
            do: dependent_module
      end

    true ->
      defp dependent_modules(%Version{}, module, modules, sources) do
        for {source,
             CE.source(
               runtime_references: r,
               compile_references: c,
               export_references: e
             )} <- sources,
            module in r or module in c or module in e,
            {dependent_module, CE.module(sources: sources)} <- modules,
            source in sources,
            do: dependent_module
      end
  end

  defp parse_version do
    System.version()
    |> Version.parse()
    |> case do
      {:ok, version} -> version
      :error -> :error
    end
  end
end
