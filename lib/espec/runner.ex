defmodule ESpec.Runner do
  @moduledoc """
  Defines functions which runs the examples.
  Uses GenServer behavior.
  """
  alias __MODULE__.Queue
  alias ESpec.Configuration
  alias ESpec.Example
  alias ESpec.Output
  alias ESpec.SuiteRunner
  alias Mix.Utils.Stale

  @doc "Starts the `ESpec.Runner` server"
  def start do
    Queue.start(:input)
    Queue.start(:output)
    Task.Supervisor.start_link(name: ESpec.TaskSupervisor)
  end

  @doc "Runs all examples."
  def run do
    do_run(ESpec.specs(), Configuration.all())
  end

  @doc false
  def stop do
    Queue.stop(:input)
    Queue.stop(:output)
    Supervisor.stop(ESpec.TaskSupervisor)
  end

  defp do_run(specs, opts) do
    {spec_modules, test_files, stale_manifest_pid} =
      case Configuration.get(:stale) do
        true ->
          set_up_stale_manifest(specs)

        _ ->
          {specs, nil, nil}
      end

    opts = Keyword.put(opts, :stale_files, test_files)

    examples =
      if Configuration.get(:order) do
        run_suites(spec_modules, opts, false)
      else
        seed_random!()
        run_suites(spec_modules, opts)
      end

    success = !Enum.any?(Example.failure(examples))

    if opts[:stale] && success, do: Stale.agent_write_manifest(stale_manifest_pid)

    Configuration.add(finish_specs_time: :os.timestamp())

    case examples do
      [] -> Mix.shell().info("No stale tests to run...")
      examples -> Output.final_result(examples)
    end

    success
  end

  defp set_up_stale_manifest(all_specs) do
    project = Mix.Project.config()
    spec_pattern = project[:spec_pattern] || "*_spec.exs"
    spec_paths = project[:spec_paths] || default_test_paths()

    matched_files = extract_files(spec_paths, spec_pattern)

    {spec_modules_to_run, test_files_to_run, pid} = Stale.set_up_stale_sources(matched_files)

    spec_modules_to_run =
      MapSet.intersection(MapSet.new(all_specs), MapSet.new(spec_modules_to_run))
      |> MapSet.to_list()

    {spec_modules_to_run, test_files_to_run, pid}
  end

  defp default_test_paths do
    if File.dir?("spec") do
      [Path.join(File.cwd!(), "spec")]
    else
      []
    end
  end

  defp extract_files(paths, pattern) do
    already_loaded = MapSet.new(Code.loaded_files())

    paths
    |> Mix.Utils.extract_files(pattern)
    |> Enum.reject(fn path ->
      full_path = Path.expand(path)

      MapSet.member?(already_loaded, full_path)
    end)
  end

  defp run_suites(specs, opts, shuffle \\ true) do
    specs
    |> Enum.reverse()
    |> Enum.map(fn module ->
      SuiteRunner.run(module, opts, shuffle)
    end)
    |> List.flatten()
  end

  defp seed_random! do
    conf_seed =
      if seed = Configuration.get(:seed) do
        seed
      else
        seed = :os.timestamp() |> elem(2)
        Configuration.add(seed: seed)
        seed
      end

    seed =
      cond do
        is_number(conf_seed) -> conf_seed
        is_binary(conf_seed) -> String.to_integer(conf_seed)
        true -> :no_way
      end

    :rand.seed(:exs64, {3172, 9814, seed})
  end

  defmodule Queue do
    @moduledoc """
    Implements queue.
    """
    def push(name, el), do: Agent.update(name, &[el | &1])

    def pop(name) do
      Agent.get_and_update(name, fn state ->
        case state do
          [el | tail] -> {el, tail}
          [] -> {nil, []}
        end
      end)
    end

    def all(name), do: Agent.get(name, & &1)
    def start(name), do: Agent.start_link(fn -> [] end, name: name)
    def clear(name), do: Agent.update(name, fn _ -> [] end)
    def stop(name), do: Agent.stop(name)
  end
end
