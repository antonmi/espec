defmodule ESpec.ExampleRunner do

  @doc """
  Runs one specific example and returns an `%ESpec.Example{}` struct.
  The sequence in the following:
  - evaluates 'befores' and 'lets'. 'befores' fill the map for `__`, 'lets' can access `__` ;
  - runs 'example block';
  - evaluate 'finally's'
  The struct has fields `[status: :success, result: result]` or `[status: failed, error: error]`
  The `result` is the value returned by example block.
  `error` is a `%ESpec.AssertionError{}` struct.
  """
	def run(example) do
		contexts = ESpec.Example.extract_contexts(example)
		cond do
      example.opts[:skip] || Enum.any?(contexts, &(&1.opts[:skip])) ->
        run_skipped(example)
      example.opts[:pending] ->
        run_pending(example)  
      true ->
        run_example(example)
    end
	end

  def run_example(example) do
    assigns = %{} 
    |> run_config_before(example)
    |> run_befores_and_lets(example)
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

  def run_skipped(example) do
    contexts = ESpec.Example.extract_contexts(example)
    example = %ESpec.Example{example | status: :pending, result: ESpec.Example.skip_message(example, contexts)}
    ESpec.Formatter.example_info(example)
    example
  end

  def run_pending(example) do 
    contexts = ESpec.Example.extract_contexts(example)
    example = %ESpec.Example{example | status: :pending, result: ESpec.Example.pending_message(example, contexts)}
    ESpec.Formatter.example_info(example)
    example
  end

  defp run_config_before(assigns, _example) do
    func = ESpec.Configuration.get(:before)
    if func, do: fill_dict(assigns, func.()), else: assigns
  end 

  defp run_befores_and_lets(assigns, example) do
    ESpec.Example.extract_befores_and_lets(example)
    |> Enum.reduce(assigns, fn(before_or_let, map) ->
      case before_or_let.__struct__ do
        ESpec.Before ->
          before = before_or_let
          returned = apply(before.module, before.function, [map])
          fill_dict(map, returned)
        ESpec.Let ->
          let = before_or_let
          ESpec.Let.agent_put({let.module, let.var}, apply(example.module, let.function, [map, let.keep_quoted]))
          map
      end
    end)
  end

  defp run_finallies(assigns, example) do
    ESpec.Example.extract_finallies(example)
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

  defp fill_dict(map, res) do
    case res do
      {:ok, list} when is_list(list) -> 
        if Keyword.keyword?(list) do
          Enum.reduce(list, map, fn({k,v}, a) -> Dict.put(a, k, v) end)
        else
          map
        end  
      _ -> map
    end
  end

 defp unload_mocks, do: ESpec.Mock.unload

end