defmodule Mix.Utils.Stale do
  import Record

  import Mix.Utils.StaleCompatible

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
      {[], []}
    else
      {:ok, pid} = Agent.start_link(fn -> sources end, name: @agent_manifest_name)
      cwd = File.cwd!()

      parallel_require_callbacks = parallel_require_callbacks(pid, cwd)

      {test_files_to_run, parallel_require_callbacks}
    end
  end

  ## Manifest

  def manifest, do: Path.join(Mix.Project.manifest_path(), @stale_manifest)

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
end
