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
  def run(opts \\ []) do
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
      contexts = extract_contexts(example.context)
      cond do
        example.opts[:skip] || Enum.any?(contexts, &(&1.opts[:skip])) ->
          run_skipped(example, contexts)
        example.opts[:pending] ->
          run_pending(example, contexts)  
        true ->
          run_example(example, module)
      end
    end)
  end

  @doc """
  Runs one specific example and returns an `%ESpec.Example{}` struct.
  The sequence in the following:
  - evaluates 'befores' and fill the map for `__`;
  - runs 'lets' (`__` can be accessed inside 'lets');
  - runs 'example block';
  - evaluate 'finally's'
  The struct has fields `[status: :success, result: result]` or `[status: failed, error: error]`
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
      ESpec.Formatter.success(example)
      %ESpec.Example{example | status: :success, result: result}
    rescue
      error in [ESpec.AssertionError] ->
        ESpec.Formatter.failure(example)
        %ESpec.Example{example | status: :failure, error: error}
    after
      run_finallies(assigns, example, module)
      |> run_config_finally(example, module)
      unload_mocks
    end
  end

  defp run_skipped(example, contexts) do
    ESpec.Formatter.pending(example)
    %ESpec.Example{example | status: :pending, result: ESpec.Example.skip_message(example, contexts)}
  end

  defp run_pending(example, contexts) do 
    ESpec.Formatter.pending(example)
    %ESpec.Example{example | status: :pending, result: ESpec.Example.pending_message(example, contexts)}
  end

  defp run_config_before(assigns, _example, _module) do
    func = ESpec.Configuration.get(:before)
    if func, do: fill_dict(assigns, func.()), else: assigns
  end 

  defp run_befores(assigns, example, module) do
    extract_befores(example.context)
    |> Enum.reduce(assigns, fn(before, map) ->
      returned = apply(module, before.function, [map])
      fill_dict(map, returned)
    end)
  end

  defp set_lets(assigns, example, module) do
    extract_lets(example.context)
    |> Enum.each(fn(let) ->
      ESpec.Let.agent_put({module, let.var}, apply(module, let.function, [assigns, let.keep_quoted]))
    end)
  end

  defp run_finallies(assigns, example, module) do
    extract_finallies(example.context)
    |> Enum.reduce(assigns, fn(finally, map) ->
      returned =  apply(module, finally.function, [map])
      fill_dict(map, returned)
    end)
  end

  defp run_config_finally(assigns, _example, _module) do
    func = ESpec.Configuration.get(:finally)
    if func do
      if is_function(func, 1), do: func.(assigns), else: func.()
    end
  end

  defp unload_mocks, do: ESpec.Mock.unload

  defp extract_befores(context), do: extract(context, ESpec.Before)
  defp extract_lets(context), do: extract(context, ESpec.Let)
  defp extract_finallies(context), do: extract(context, ESpec.Finally)
  defp extract_contexts(context), do: extract(context, ESpec.Context)

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
    file_opts = opts[:file_opts] || []
    if Enum.any?(file_opts) do
      examples = file_opts_filter(examples, file_opts)
    end
    examples
  end

  defp file_opts_filter(examples, file_opts) do
    Enum.filter(examples, fn(example) ->
      opts = opts_for_file(example.file, file_opts)
      line = Keyword.get(opts, :line)
      if line, do: example.line == line, else: true
    end)
  end

  defp opts_for_file(file, opts_list) do
    case opts_list |> Enum.find(fn {k, _} -> k == file end) do
      {_file, opts} -> opts
      nil -> []
    end
  end

end
