defmodule ESpec.Runner do
  @moduledoc """
  Defines functions which runs the examples.
  """

  @doc """
  Runs all examples.
  Uses `filter/2` to select examples to run.
  """
  def run do
    opts = ESpec.Configuration.all
    ESpec.specs |> Enum.reverse
    |> Enum.map(fn(module) ->
      filter(module.examples, opts)
      |> run_examples
    end)
    |> List.flatten
  end

  @doc "Runs example for specific 'spec  module'."
  def run_examples(examples) do
    examples
    |> Enum.map(fn(example) ->
      contexts = extract_contexts(example.context)
      cond do
        example.opts[:skip] || Enum.any?(contexts, &(&1.opts[:skip])) ->
          run_skipped(example, contexts)
        example.opts[:pending] ->
          run_pending(example, contexts)  
        true ->
          run_example(example)
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
  def run_example(example) do
    assigns = %{} 
    |> run_config_before(example)
    |> run_befores(example)
    set_lets(assigns, example)
    try do
      result = apply(example.module, example.function, [assigns])
      example = %ESpec.Example{example | status: :success, result: result}
      ESpec.Formatter.example_info(example)
      example
    rescue
      error in [ESpec.AssertionError] ->
        example = %ESpec.Example{example | status: :failure, error: error}
        ESpec.Formatter.example_info(example)
        example
    after
      run_finallies(assigns, example)
      |> run_config_finally(example)
      unload_mocks
    end
  end

  defp run_skipped(example, contexts) do
    example = %ESpec.Example{example | status: :pending, result: ESpec.Example.skip_message(example, contexts)}
    ESpec.Formatter.example_info(example)
    example
  end

  defp run_pending(example, contexts) do 
    example = %ESpec.Example{example | status: :pending, result: ESpec.Example.pending_message(example, contexts)}
    ESpec.Formatter.example_info(example)
    example
  end

  defp run_config_before(assigns, _example) do
    func = ESpec.Configuration.get(:before)
    if func, do: fill_dict(assigns, func.()), else: assigns
  end 

  defp run_befores(assigns, example) do
    extract_befores(example.context)
    |> Enum.reduce(assigns, fn(before, map) ->
      returned = apply(example.module, before.function, [map])
      fill_dict(map, returned)
    end)
  end

  defp set_lets(assigns, example) do
    extract_lets(example.context)
    |> Enum.each(fn(let) ->
      ESpec.Let.agent_put({example.module, let.var}, apply(example.module, let.function, [assigns, let.keep_quoted]))
    end)
  end

  defp run_finallies(assigns, example) do
    extract_finallies(example.context)
    |> Enum.reduce(assigns, fn(finally, map) ->
      returned =  apply(example.module, finally.function, [map])
      fill_dict(map, returned)
    end)
  end

  defp run_config_finally(assigns, _example) do
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
    if opts[:focus] do
      examples = filter_focus(examples)
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

  defp filter_focus(examples) do
    Enum.filter(examples, fn(example) ->
      contexts = extract_contexts(example.context)
      example.opts[:focus] || Enum.any?(contexts, &(&1.opts[:focus]))
    end)
  end

end
