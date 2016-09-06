defmodule ESpec.AssertReceive do
  @moduledoc """
  Defines `assert_receive` and `assert_received` helper macros
  """
  @default_timeout 100

  defmodule AssertReceiveError do
    defexception message: nil
  end

  alias ESpec.ExpectTo
  alias ESpec.Assertions.AssertReceive

  @doc "Asserts that a message matching `pattern` was or is going to be received."
  defmacro assert_receive(pattern, timeout \\ @default_timeout) do
    do_assert_receive(pattern, timeout, __CALLER__)
  end

  @doc "Asserts that a message matching `pattern` was received and is in the current process' mailbox."
  defmacro assert_received(pattern) do
    do_assert_receive(pattern, 0, __CALLER__)
  end

  defp do_assert_receive(pattern, timeout, caller) do
    binary = Macro.to_string(pattern)
    pattern = Macro.expand(pattern, caller)

    vars = collect_vars_from_pattern(pattern)
    pins = collect_pins_from_pattern(pattern)

    pattern =
      case pattern do
        {:when, meta, [left, right]} ->
          {:when, meta, [quote(do: unquote(left) = received), right]}
        left ->
          quote(do: unquote(left) = received)
      end

    ESpec.AssertReceive.__assert_receive__(pattern, binary, vars, pins, timeout)
  end

  @doc false
  def __assert_receive__(pattern, binary, vars, pins, timeout \\ 100) do
    quote do
      result =
        {received, unquote(vars)} =
          receive do
            unquote(pattern) -> {received, unquote(vars)}
          after
            unquote(timeout) ->
              args = [unquote(binary), unquote(pins), ESpec.AssertReceive.__mailbox_messages__]
              ExpectTo.to({AssertReceive, args}, {ExpectTo, {:error, :timeout}})
          end
      args = [unquote(binary), unquote(pins), ESpec.AssertReceive.__mailbox_messages__]
      ExpectTo.to({AssertReceive, args}, {ExpectTo, result})
    end
  end

  @max_mailbox_length 10

  @doc false
  def __mailbox_messages__ do
    {:messages, messages} = Process.info(self(), :messages)
    Enum.take(messages, @max_mailbox_length)
  end

  defp collect_pins_from_pattern(expr) do
    {_, pins} =
      Macro.prewalk(expr, [], fn
        {:^, _, [{name, _, _} = var]}, acc ->
          {:ok, [{name, var} | acc]}
        form, acc ->
          {form, acc}
      end)
    Enum.uniq_by(pins, &elem(&1, 0))
  end

  defp collect_vars_from_pattern({:when, _, [left, right]}) do
    pattern = collect_vars_from_pattern(left)
    for {name, _, context} = var <- collect_vars_from_pattern(right),
      Enum.any?(pattern, &match?({^name, _, ^context}, &1)),
      into: pattern,
      do: var
  end

  defp collect_vars_from_pattern(expr) do
    Macro.prewalk(expr, [], fn
      {:::, _, [left, _]}, acc ->
        {[left], acc}
      {skip, _, [_]}, acc when skip in [:^, :@] ->
        {:ok, acc}
      {:_, _, context}, acc when is_atom(context) ->
        {:ok, acc}
      {name, meta, context}, acc when is_atom(name) and is_atom(context) ->
        {:ok, [{name, [generated: true] ++ meta, context} | acc]}
      any_node, acc ->
        {any_node, acc}
    end)
    |> elem(1)
  end
end
