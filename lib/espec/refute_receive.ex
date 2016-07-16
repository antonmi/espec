defmodule ESpec.RefuteReceive do
  @moduledoc """
  Defines `refute_receive` and `refute_received` helper macros
  """
  @default_timeout 100

  defmodule RefuteReceiveError do
    defexception message: nil
  end

  alias ESpec.ExpectTo
  alias ESpec.Assertions.RefuteReceive

  @doc "Asserts that a message matching `pattern` was not received (and won't be received) within the `timeout` period."
  defmacro refute_receive(pattern, timeout \\ @default_timeout) do
    do_refute_receive(pattern, timeout)
  end

  @doc "Asserts a message matching `pattern` was not received (i.e. it is not in the current process' mailbox)"
  defmacro refute_received(pattern) do
    do_refute_receive(pattern, 0)
  end

  defp do_refute_receive(pattern, timeout) do
    binary = Macro.to_string(pattern)
    ESpec.RefuteReceive.received?(pattern, binary, timeout)
  end

  @doc false
  def received?(pattern, binary, timeout \\ 100) do
    quote do
      result =
        receive do
          unquote(pattern) -> unquote(pattern)
        after
          unquote(timeout) -> false
        end

      ExpectTo.to({RefuteReceive, unquote(binary)}, {ExpectTo, result})
    end
  end
end
