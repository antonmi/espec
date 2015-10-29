defmodule ESpec.Assertions.Boolean.BeTruthy do
  @moduledoc """
  Defines 'be_true' assertion.

  it do: expect(1).to be_truthy
  """
  use ESpec.Assertions.Interface

  defp match(subject, _val) do
    result = if subject, do: true, else: false
    {result, result}
  end

  defp success_message(subject, _val, _result, positive) do
    to = if positive, do: "is", else: "is not"
    "`#{inspect subject}` #{to} truthy."
  end

  defp error_message(subject, _val, _result, positive) do
    to = if positive, do: "to", else: "not to"
    but = if positive, do: "it isn't", else: "it is"
    "Expected `#{inspect subject}` #{to} be truthy but #{but}."
  end
end
