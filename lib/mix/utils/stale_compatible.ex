defmodule Mix.Utils.StaleCompatible do
  @moduledoc false
  # This module was written to deal with the incompatibilies between Elixir <= 1.9
  # and the release of Elixir 1.10. It is expected to eventually go away if certain
  # private APIs in Elixir become public.

  require Mix.Compilers.Elixir, as: CE

  import Record

  alias Mix.Utils.Stale

  defrecordp :source,
    source: nil,
    compile_references: [],
    runtime_references: [],
    external: []

  defmacro __using__(_args) do
    quote do
      require Mix.Compilers.Elixir, as: CE
      import Mix.Utils.StaleCompatible

      def parallel_require_callbacks(pid, cwd),
        do:
          Mix.Utils.StaleCompatible.parse_version()
          |> Mix.Utils.StaleCompatible.parallel_require_callbacks(pid, cwd)
    end
  end

  defmacro tests_with_changed_references(test_sources),
    do:
      Mix.Utils.StaleCompatible.parse_version()
      |> Mix.Utils.StaleCompatible.tests_with_changed_references(test_sources)

  def parse_version do
    System.version()
    |> Version.parse()
    |> case do
      {:ok, version} -> version
      :error -> :error
    end
  end

  ## Test changed dependency resolution

  def tests_with_changed_references(%Version{major: 1, minor: minor}, test_sources)
      when minor >= 10 do
    quote bind_quoted: [minor: minor, test_sources: test_sources] do
      test_manifest = Stale.manifest()
      [elixir_manifest] = Mix.Tasks.Compile.Elixir.manifests()

      if Mix.Utils.stale?([elixir_manifest], [test_manifest]) do
        compile_path = Mix.Project.compile_path()
        {elixir_modules, elixir_sources} = CE.read_manifest(elixir_manifest)

        stale_modules =
          for CE.module(module: module) <- elixir_modules,
              beam = Path.join(compile_path, Atom.to_string(module) <> ".beam"),
              Mix.Utils.stale?([beam], [test_manifest]),
              do: module,
              into: MapSet.new()

        stale_modules = find_all_dependent_on(stale_modules, elixir_modules, elixir_sources)

        for module <- stale_modules,
            source(source: source, runtime_references: r, compile_references: c) <- test_sources,
            module in r or module in c,
            do: source,
            into: MapSet.new()
      else
        MapSet.new()
      end
    end
  end

  def tests_with_changed_references(%Version{major: 1, minor: minor}, test_sources)
      when minor < 10 do
    quote bind_quoted: [minor: minor, test_sources: test_sources] do
      test_manifest = Stale.manifest()
      [elixir_manifest] = Mix.Tasks.Compile.Elixir.manifests()

      if Mix.Utils.stale?([elixir_manifest], [test_manifest]) do
        elixir_manifest_entries =
          CE.read_manifest(elixir_manifest, Mix.Project.compile_path())
          |> Enum.group_by(&elem(&1, 0))

        stale_modules =
          for CE.module(module: module, beam: beam) <- elixir_manifest_entries.module,
              Mix.Utils.stale?([beam], [test_manifest]),
              do: module,
              into: MapSet.new()

        stale_modules =
          find_all_dependent_on(
            stale_modules,
            elixir_manifest_entries.source,
            elixir_manifest_entries.module
          )

        for module <- stale_modules,
            source(source: source, runtime_references: r, compile_references: c) <- test_sources,
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
        each_file: &each_file(pid, &1, &2)
      ]

  def parallel_require_callbacks(%Version{major: 1, minor: minor} = version, pid, cwd)
      when minor >= 6 and minor < 9 do
    [each_module: &each_module(version, pid, cwd, &1, &2, &3)]
  end

  def parallel_require_callbacks(_, _, _),
    do: {:error, "Your version of Elixir #{System.version()} cannot support the stale feature"}

  defp each_module(%Version{major: 1, minor: minor}, pid, cwd, file, module, _binary)
       when minor >= 9 do
    quote bind_quoted: [pid: pid, cwd: cwd, file: file, module: module] do
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
  end

  defp each_module(%Version{major: 1, minor: minor}, pid, cwd, source, module, _binary)
       when minor >= 6 and minor < 9 do
    quote bind_quoted: [pid: pid, cwd: cwd, source: source, module: module] do
      {compile_references, struct_references, runtime_references} =
        Kernel.LexicalTracker.remote_references(module)

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
  end

  defp each_file(pid, file, lexical) do
    quote bind_quoted: [pid: pid, file: file, lexical: lexical] do
      Agent.update(pid, fn sources ->
        case List.keytake(sources, file, source(:source)) do
          {source, sources} ->
            {compile_references, struct_references, runtime_references} =
              Kernel.LexicalTracker.remote_references(lexical)

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
  end

  def get_external_resources(module, cwd) do
    for file <- Module.get_attribute(module, :external_resource),
        do: Path.relative_to(file, cwd)
  end

  def find_all_dependent_on(modules, sources, all_modules, resolved \\ MapSet.new()) do
    new_modules =
      for module <- modules,
          module not in resolved,
          dependent_module <- dependent_modules(module, all_modules, sources),
          do: dependent_module,
          into: modules

    if MapSet.size(new_modules) == MapSet.size(modules) do
      new_modules
    else
      find_all_dependent_on(new_modules, sources, all_modules, modules)
    end
  end

  def dependent_modules(module, modules, sources) do
    for CE.source(source: source, runtime_references: r, compile_references: c) <- sources,
        module in r or module in c,
        CE.module(sources: sources, module: dependent_module) <- modules,
        source in sources,
        do: dependent_module
  end
end
