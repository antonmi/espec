defmodule ESpec.ExampleRunner do
  @moduledoc """
  Contains all the functions need to run a 'spec' example.
  """

  @dict_keys [:ok, :shared]

  @doc """
  Runs one specific example and returns an `%ESpec.Example{}` struct.
  The sequence in the following:
  - evaluates 'befores' and 'lets'. 'befores' fill the map for `shared`, 'lets' can access `shared` ;
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
        run_example(example, :os.timestamp)
    end
  end

  defp run_example(example, start_time) do
    try do
      assigns = before_example_actions(example)
      result = case apply(example.module, example.function, [assigns]) do
        {ESpec.ExpectTo, res} -> res
        res -> res
      end
      duration = duration_in_ms(start_time, :os.timestamp)
      example = %ESpec.Example{example | status: :success, result: result, duration: duration}
      ESpec.Output.example_info(example)

      after_example_actions(assigns, example)

      example
    rescue
      error in [ESpec.AssertionError] ->
        duration = duration_in_ms(start_time, :os.timestamp)
        example = %ESpec.Example{example | status: :failure, error: error, duration: duration}
        ESpec.Output.example_info(example)
        example
      other_error ->
        error = %ESpec.AssertionError{message: format_other_error(other_error)}
        duration = duration_in_ms(start_time, :os.timestamp)
        example = %ESpec.Example{example | status: :failure, error: error, duration: duration}
        ESpec.Output.example_info(example)
        example
    after
      unload_mocks
    end
  end

  defp before_example_actions(example) do
    %{}
    |> run_config_before(example)
    |> run_befores_and_lets(example)
  end

  def after_example_actions(assigns, example) do
    run_finallies(assigns, example)
    |> run_config_finally(example)
  end


  defp format_other_error(error) do
    error_message = Exception.format_banner(:error, error)
    stacktrace = Exception.format_stacktrace(System.stacktrace)
    error_message <> "\n" <> stacktrace
  end

  defp run_skipped(example) do
    example = %ESpec.Example{example | status: :pending, result: ESpec.Example.skip_message(example)}
    ESpec.Output.example_info(example)
    example
  end

  defp run_pending(example) do
    example = %ESpec.Example{example | status: :pending, result: ESpec.Example.pending_message(example)}
    ESpec.Output.example_info(example)
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
          ESpec.Let.agent_put({self, let.module, let.var}, apply(let.module, let.function, [map, let.keep_quoted]))
          map
      end
    end)
  end

  defp run_finallies(assigns, example) do
    ESpec.Example.extract_finallies(example)
    |> Enum.reduce(assigns, fn(finally, map) ->
      returned =  apply(finally.module, finally.function, [map])
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
      {key, list} when key in @dict_keys and is_list(list) ->
        if Keyword.keyword?(list) do
          Enum.reduce(list, map, fn({k,v}, a) -> Dict.put(a, k, v) end)
        else
          map
        end
      _ -> map
    end
  end

  defp unload_mocks, do: ESpec.Mock.unload

  defp duration_in_ms(start_time, end_time) do
    div(:timer.now_diff(end_time, start_time), 1000)
  end
end
