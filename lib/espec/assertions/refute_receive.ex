defmodule ESpec.Assertions.RefuteReceive do
  @moduledoc """
  Defines 'refute_receive' and 'refute_received' assertions.

  it do: refute_receive :hello
  """
  use ESpec.Assertions.Interface

  defp match(subject, pattern) do
    case subject do
      false -> {true, pattern}
      true -> {false, pattern}
    end
  end

  defp success_message(_subject, _pattern, result, _positive) do
    "Have not received `#{result}`."
  end

  defp error_message(_subject, _pattern, result, _positive) do
    "Expected not to receive `#{result}`, but have received."
  end
end
