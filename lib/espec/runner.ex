defmodule ESpec.Runner do
  @moduledoc """
  Defines functions which runs the examples.
  Uses GenServer behavior.
  """
  alias ESpec.Configuration
  alias ESpec.Example
  alias __MODULE__.Queue

  @doc "Starts the `ESpec.Runner` server"
  def start do
    Queue.start(:input)
    Queue.start(:output)
  end

  @doc "Runs all examples."
  def run do
    do_run(ESpec.specs, Configuration.all)
  end

  @doc false
  def stop do
    Queue.stop(:input)
    Queue.stop(:output)
  end

  defp do_run(specs, opts) do
    examples = if Configuration.get(:order) do
      run_suites(specs, opts, false)
    else
      seed_random!()
      run_suites(specs, opts)
    end
    Configuration.add([finish_specs_time: :os.timestamp])
    ESpec.Output.print_result(examples)
    !Enum.any?(Example.failure(examples))
  end

  defp run_suites(specs, opts, shuffle \\ true) do
    specs |> Enum.reverse
    |> Enum.map(fn(module) ->
      ESpec.SuiteRunner.run(module, opts, shuffle)
    end)
    |> List.flatten
  end

  defp seed_random! do
    conf_seed = if seed = Configuration.get(:seed) do
      seed
    else
      seed = :os.timestamp |> elem(2)
      Configuration.add(seed: seed)
      seed
    end

    seed = cond do
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
      Agent.get_and_update(name, fn(state) ->
        case state do
          [el | tail] -> {el, tail}
          [] -> {nil, []}
        end
      end)
    end

    def all(name), do: Agent.get(name, &(&1))
    def start(name), do: Agent.start_link(fn -> [] end, name: name)
    def clear(name), do: Agent.update(name, fn(_) -> [] end)
    def stop(name), do: Agent.stop(name)
  end
end
