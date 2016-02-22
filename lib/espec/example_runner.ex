defmodule ESpec.ExampleRunner do
  @moduledoc """
  Contains all the functions need to run a 'spec' example.
  """

  @dict_keys [:ok, :shared]

  alias ESpec.Example
  alias ESpec.AssertionError
  alias ESpec.Output

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
    contexts = Example.extract_contexts(example)
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
    {assigns, example} = before_example_actions(example)
    try do
      try_run(example, assigns, start_time)
    catch
      what, value -> do_catch(example, assigns, start_time, what, value)
    rescue
      error in [AssertionError] -> do_rescue(example, assigns, start_time, error)
      other_error ->
        error = %AssertionError{message: format_other_error(other_error)}
        do_rescue(example, assigns, start_time, error)
    after
      unload_mocks
    end
  end

  defp before_example_actions(example) do
    {%{}, example}
    |> run_config_before
    |> run_befores_and_lets
  end

  defp try_run(example, assigns, start_time) do
    if example.status == :failure, do: raise example.error

    result = case apply(example.module, example.function, [assigns]) do
      {ESpec.ExpectTo, res} -> res
      res -> res
    end

    duration = duration_in_ms(start_time, :os.timestamp)
    example = %Example{example | status: :success, result: result, duration: duration}
    Output.example_info(example)
    after_example_actions(assigns, example)
    example
  end

  defp do_catch(example, assigns, start_time, what, value) do
    duration = duration_in_ms(start_time, :os.timestamp)
    error = %AssertionError{message: format_catch(what, value)}
    example = %Example{example | status: :failure, error: error, duration: duration}
    Output.example_info(example)
    after_example_actions(assigns, example)
    example
  end

  defp do_rescue(example, assigns, start_time, error) do
    duration = duration_in_ms(start_time, :os.timestamp)
    example = %Example{example | status: :failure, error: error, duration: duration}
    Output.example_info(example)
    after_example_actions(assigns, example)
    example
  end

  def after_example_actions(assigns, example) do
    run_finallies(assigns, example)
    |> run_config_finally(example)
  end

  defp run_skipped(example) do
    example = %Example{example | status: :pending, result: Example.skip_message(example)}
    Output.example_info(example)
    example
  end

  defp run_pending(example) do
    example = %Example{example | status: :pending, result: Example.pending_message(example)}
    Output.example_info(example)
    example
  end

  defp run_config_before({assigns, example}) do
    func = ESpec.Configuration.get(:before)
    if func do
      try do
        {fill_dict(assigns, func.()), example}
      catch
        what, value -> catch_before(what, value, {assigns, example})
      rescue
        any_error -> rescure_before(any_error, {assigns, example})
      end
    else
      {assigns, example}
    end
  end

  defp run_befores_and_lets({assigns, example}) do
    Example.extract_befores_and_lets(example)
    |> Enum.reduce({assigns, example}, fn(before_or_let, {map, example}) ->
      try do
        assigns = do_run_befores_and_let(before_or_let, example, map)
        {assigns, example}
      catch
        what, value -> catch_before(what, value, {map, example})
      rescue
        any_error -> rescure_before(any_error, {map, example})
      end
    end)
  end

  defp catch_before(what, value, {map, example}) do
    error = %AssertionError{message: format_catch(what, value)}
    example = %Example{example | status: :failure, error: error}
    {map, example}
  end

  defp rescure_before(error, {map, example}) do
    error = %AssertionError{message: format_other_error(error)}
    example = %Example{example | status: :failure, error: error}
    {map, example}
  end

  defp do_run_befores_and_let(before_or_let, example, map) do
    case before_or_let.__struct__ do
      ESpec.Before ->
        before = before_or_let
        returned = apply(before.module, before.function, [map])
        fill_dict(map, returned)
      ESpec.Let ->
        let = before_or_let
        ESpec.Let.agent_put({self, let.module, let.var}, apply(let.module, let.function, [map]))
        map
    end
  end

  defp run_finallies(assigns, example) do
    Example.extract_finallies(example)
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

  defp format_other_error(error) do
    error_message = Exception.format_banner(:error, error)
    stacktrace = Exception.format_stacktrace(System.stacktrace)
    error_message <> "\n" <> stacktrace
  end

  defp format_catch(what, value), do: "#{what} #{inspect value}"
end
