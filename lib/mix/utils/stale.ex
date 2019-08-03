defmodule Mix.Utils.Stale do
  import Record

  require Mix.Compilers.Elixir, as: CE

  defrecordp :source,
    source: nil,
    compile_references: [],
    runtime_references: [],
    external: []

  @stale_manifest "compile.espec_stale"
  @manifest_vsn 1
  @agent_manifest_name :espec_stale_manifest_agent

  # set up stale manifest
  def set_up_stale_sources(matched_test_files) do
    manifest = manifest()
    modified = Mix.Utils.last_modified(manifest)
    all_sources = read_manifest()

    removed =
      for source(source: source) <- all_sources,
          source not in matched_test_files,
          do: Path.expand(source)

    sources_mtimes = mtimes(all_sources)

    # Let's start with the new sources
    # Plus the sources that have changed in disk
    changed =
      for(
        source <- matched_test_files,
        not List.keymember?(all_sources, source, source(:source)),
        do: source
      ) ++
        for(
          source(source: source, external: external) <- all_sources,
          times = Enum.map([source | external], &Map.fetch!(sources_mtimes, &1)),
          Mix.Utils.stale?(times, [modified]),
          do: source
        )

    stale = MapSet.new(changed -- removed)
    sources = update_stale_sources(all_sources, removed, changed)

    test_files_to_run =
      sources
      |> tests_with_changed_references()
      |> MapSet.union(stale)
      |> MapSet.to_list()

    if test_files_to_run == [] do
      write_manifest(sources)
      []
    else
      {:ok, _pid} = Agent.start_link(fn -> sources end, name: @agent_manifest_name)
      test_files_to_run
    end
  end

  ## Manifest

  def write_manifest([]) do
    File.rm(manifest())
    :ok
  end

  def write_manifest(sources) do
    manifest = manifest()
    File.mkdir_p!(Path.dirname(manifest))

    manifest_data = :erlang.term_to_binary([@manifest_vsn | sources], [:compressed])
    File.write!(manifest, manifest_data)
  end

  defp manifest, do: Path.join(Mix.Project.manifest_path(), @stale_manifest)

  defp read_manifest() do
    try do
      [@manifest_vsn | sources] = manifest() |> File.read!() |> :erlang.binary_to_term()
      sources
    rescue
      _ -> []
    end
  end

  def agent_manifest_name(), do: @agent_manifest_name

  def agent_write_manifest() do
    Agent.cast(@agent_manifest_name, fn sources ->
      write_manifest(sources)
      sources
    end)
  end

  ## Setup helpers

  defp mtimes(sources) do
    Enum.reduce(sources, %{}, fn source(source: source, external: external), map ->
      Enum.reduce([source | external], map, fn file, map ->
        Map.put_new_lazy(map, file, fn -> Mix.Utils.last_modified(file) end)
      end)
    end)
  end

  defp update_stale_sources(sources, removed, changed) do
    sources = Enum.reject(sources, fn source(source: source) -> source in removed end)

    sources =
      Enum.reduce(changed, sources, &List.keystore(&2, &1, source(:source), source(source: &1)))

    sources
  end

  ## Test changed dependency resolution

  defp tests_with_changed_references(test_sources) do
    test_manifest = manifest()
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

  defp find_all_dependent_on(modules, sources, all_modules, resolved \\ MapSet.new()) do
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

  defp dependent_modules(module, modules, sources) do
    for CE.source(source: source, runtime_references: r, compile_references: c) <- sources,
        module in r or module in c,
        CE.module(sources: sources, module: dependent_module) <- modules,
        source in sources,
        do: dependent_module
  end
end
