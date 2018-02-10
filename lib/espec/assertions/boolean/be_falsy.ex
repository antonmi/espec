defmodule ESpec.Assertions.Boolean.BeFalsy do
  @moduledoc """
  Defines 'be_true' assertion.

  it do: expect(1).to be_falsy
  """
  use ESpec.Assertions.Interface

  defp match(subject, _val) do
    result = if subject, do: false, else: true
    {result, result}
  end

  defp success_message(subject, _val, _result, positive) do
    to = if positive, do: "is", else: "is not"
    "`#{inspect(subject)}` #{to} falsy."
  end

  defp error_message(subject, _val, _result, positive) do
    to = if positive, do: "to", else: "not to"
    but = if positive, do: "it isn't", else: "it is"
    "Expected `#{inspect(subject)}` #{to} be falsy but #{but}."
  end
end
