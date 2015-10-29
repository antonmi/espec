defmodule ESpec.Assertions.ListString.HaveLast do
  @moduledoc """
  Defines 'have_last' assertion.

  it do: expect(list).to have_last(value)

  it do: expect(string).to have_last(value)
  """
  use ESpec.Assertions.Interface

  defp match(list, val) when is_binary(list) do
    result = String.last(list)
    {result == val, result}
  end

  defp match(list, val) do
    result = List.last(list)
    {result == val, result}
  end

  defp success_message(list, val, _result, positive) do
    to = if positive, do: "has", else: "doesn't have"
    "`#{inspect list}` #{to} last element `#{inspect val}`."
  end

  defp error_message(list, val, result, positive) do
    to = if positive, do: "to", else: "not to"
    "Expected `#{inspect list}` #{to} have last element `#{inspect val}` but it has `#{result}`."
  end

end
