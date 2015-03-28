defmodule ESpec.Runner do
  @moduledoc """
  Defines functions which runs the examples.
  """

  @doc """
  Runs all examples.
  Uses `filter/2` to select examples to run.
  The options are:
  TODO
  """
  def run(opts) do
    ESpec.specs |> Enum.reverse
    |> Enum.map(fn(module) ->
      filter(module.examples, opts)
      |> run_examples(module)
    end)
    |> List.flatten
  end

  @doc "Runs example for specific 'spec  module'."
  def run_examples(examples, module) do
    examples
    |> Enum.map(fn(example) ->
      run_example(example, module)
    end)
  end

  @doc """
  Runs one specific example and returns an `%ESpec.Example{}` struct.
  The sequence in the following:
  - evaluates 'befores' and fill the map for `__`;
  - runs 'lets' (`__` can be accessed inside 'lets');
  - runs 'example block';
  - evaluate 'finally's'
  The struct has fields `[success: true, result: result]` or `[success: false, error: error]`
  The `result` is the value returned by example block.
  `error` is a `%ESpec.AssertionError{}` struct.
  """
  def run_example(example, module) do
    assigns = %{} 
    |> run_config_before(example, module)
    |> run_befores(example, module)
    set_lets(assigns, example, module)
    try do
      result = apply(module, example.function, [assigns])
      IO.write("\e[32;1m.\e[0m")
      %ESpec.Example{example | success: true, result: result}
    rescue
      error in [ESpec.AssertionError] ->
        IO.write("\e[31;1mF\e[0m")
        %ESpec.Example{example | success: false, error: error}
    after
      run_finallies(assigns, example, module)
      |> run_config_finally(example, module)
      unload_mocks
    end
  end

  @doc "defines public functions for testing purpose"
  if Mix.env == :test do
    def run_config_before(assigns, _example, _module), do: do_run_config_before(assigns, _example, _module)
    def run_befores(assigns, example, module), do: do_run_befores(assigns, example, module)
    def set_lets(assigns, example, module), do: do_set_lets(assigns, example, module)
    def run_finallies(example, module, assigns), do: do_run_finallies(example, module, assigns)
    def run_config_finally(assigns, example, module), do: do_run_config_finally(assigns, example, module)
  else
    defp run_config_before(assigns, _example, _module), do: do_run_config_before(assigns, _example, _module)
    defp run_befores(assigns, example, module), do: do_run_befores(assigns, example, module)
    defp set_lets(assigns, example, module), do: do_set_lets(assigns, example, module)
    defp run_finallies(example, module, assigns), do: do_run_finallies(example, module, assigns)
    defp run_config_finally(assigns, example, module), do: do_run_config_finally(assigns, example, module)
  end

  defp do_run_config_before(assigns, _example, _module) do
    func = ESpec.Configuration.get(:before)
    if func, do: fill_dict(assigns, func.()), else: assigns
  end 

  defp do_run_befores(assigns, example, module) do
    extract_befores(example.context)
    |> Enum.reduce(assigns, fn(before, map) ->
      returned = apply(module, before.function, [map])
      fill_dict(map, returned)
    end)
  end

  defp do_set_lets(assigns, example, module) do
    extract_lets(example.context)
    |> Enum.each(fn(let) ->
      ESpec.Let.agent_put({module, let.var}, apply(module, let.function, [assigns, let.keep_quoted]))
    end)
  end

  defp do_run_finallies(assigns, example, module) do
    res = extract_finallies(example.context)
    |> Enum.reduce(assigns, fn(finally, map) ->
      returned =  apply(module, finally.function, [map])
      fill_dict(map, returned)
    end)
  end

  defp do_run_config_finally(assigns, example, module) do
    func = ESpec.Configuration.get(:finally)
    if func do
      if is_function(func, 1), do: func.(assigns), else: func.()
    end
  end

  defp unload_mocks, do: ESpec.Mock.unload

  defp extract_befores(context), do: extract(context, ESpec.Before)
  defp extract_lets(context), do: extract(context, ESpec.Let)
  defp extract_finallies(context), do: extract(context, ESpec.Finally)

  defp extract(context, module) do
    context |>
    Enum.filter(fn(struct) ->
      struct.__struct__ == module
    end)
  end

  defp fill_dict(map, res) do
    case res do
      {:ok, list} when is_list(list) -> 
        Enum.reduce(list, map, fn({k,v}, a) -> Dict.put(a, k, v) end)
      _ -> map
    end
  end

  defp filter(examples, opts) do
    file_opts = opts[:file_opts]
    if file_opts do
      examples |> Enum.filter(fn(example) ->
        opts = opts_for_file(example.file, file_opts)
        line = Keyword.get(opts, :line)
        if line, do: example.line == line, else: true
      end)
    else
      examples
    end
  end

  defp opts_for_file(file, opts_list) do
    case opts_list |> Enum.find(fn {k, _} -> k == file end) do
      {_file, opts} -> opts
      nil -> []
    end
  end

end
