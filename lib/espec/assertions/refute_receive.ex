defmodule ESpec.Assertions.RefuteReceive do
  @moduledoc """
  Defines 'refute_receive' and 'refute_received' assertions.

  it do: refute_receive :hello
  """
  use ESpec.Assertions.Interface

  @join_sym "\n\t"

  defp match(subject, pattern) do
    case subject do
      false -> {true, pattern}
      pattern -> {false, pattern}
    end
  end

  defp success_message(_subject, _pattern, result, _positive) do
    "Have not received `#{inspect result}`."
  end

  defp error_message(_subject, _pattern, result, _positive) do
    "Expected not to receive `#{inspect result}`, but have received."
  end
end
