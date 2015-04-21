defmodule ESpec.Runner do
  @moduledoc """
  Defines functions which runs the examples.
  """
  use GenServer

  def start do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    state = %{specs: ESpec.specs, opts: ESpec.Configuration.all}
    {:ok, state}
  end

  @doc """
  Runs all examples.
  """
  def run, do: GenServer.call(__MODULE__, :run, :infinity)

  def handle_call(:run, _pid, state) do
    result = do_run(state[:specs], state[:opts])
    {:reply, result, state}
  end

  defp do_run(specs, opts) do
    if ESpec.Configuration.get(:order) do
      examples = run_in_order(specs, opts)
    else
      examples = run_in_random(specs, opts)
    end

    ESpec.Output.print_result(examples)
    !Enum.any?(ESpec.Example.failure(examples))
  end

  defp run_in_order(specs, opts) do
    specs |> Enum.reverse
    |> Enum.map(fn(module) ->
      filter(module.examples, opts)
      |> run_examples
    end)
    |> List.flatten
  end    

  defp run_in_random(specs, opts) do
    examples = Enum.map(specs, fn(module) -> 
      filter(module.examples, opts)
    end) |> List.flatten |> Enum.shuffle

    run_examples(examples)
  end

  @doc "Runs examples."
  def run_examples(examples) do
    {async, sync} = Enum.partition(examples, &(&1.async))
    run_async(async) ++ run_sync(sync)
  end

  defp run_async(examples) do
    examples
    |> Enum.map(fn(example) ->
      Task.async(fn -> ESpec.ExampleRunner.run(example) end)
    end)
    |> Enum.map(fn(task) ->
      Task.await(task, :infinity)
    end)
  end

  defp run_sync(examples) do
    Enum.map(examples, fn(example) ->
      ESpec.ExampleRunner.run(example) 
    end)
  end

  defp filter(examples, opts) do
    file_opts = opts[:file_opts] || []
    examples = filter_shared(examples)
    if Enum.any?(file_opts) do
      examples = file_opts_filter(examples, file_opts)
    end
    if opts[:focus] do
      examples = filter_focus(examples)
    end
    examples
  end

  defp filter_shared(examples) do
    Enum.filter(examples, &(!&1.shared))
  end

  defp file_opts_filter(examples, file_opts) do
    Enum.filter(examples, fn(example) ->
      opts = opts_for_file(example.file, file_opts)
      line = Keyword.get(opts, :line)
      if line do
        lines = ESpec.Example.extract_contexts(example)
        |> Enum.map(&(&1.line))
        Enum.member?([example.line | lines], line)
      else
        true
      end
    end)
  end

  defp opts_for_file(file, opts_list) do
    case opts_list |> Enum.find(fn {k, _} -> k == file end) do
      {_file, opts} -> opts
      nil -> []
    end
  end

  defp filter_focus(examples) do
    Enum.filter(examples, fn(example) ->
      contexts = ESpec.Example.extract_contexts(example)
      example.opts[:focus] || Enum.any?(contexts, &(&1.opts[:focus]))
    end)
  end

end
