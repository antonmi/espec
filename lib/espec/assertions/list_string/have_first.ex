defmodule ESpec.Assertions.ListString.HaveFirst do
  @moduledoc """
  Defines 'have_first' assertion.

  it do: expect(list).to have_first(value)

  it do: expect(string).to have_first(value)
  """
  use ESpec.Assertions.Interface

  defp match(list, val) when is_binary(list) do
    result = String.first(list)
    {result == val, result}
  end

  defp match(list, val) do
    result = List.first(list)
    {result == val, result}
  end

  defp success_message(list, val, _result, positive) do
    to = if positive, do: "has", else: "doesn't have"
    "`#{inspect list}` #{to} first element `#{inspect val}`."
  end

  defp error_message(list, val, result, positive) do
    to = if positive, do: "to", else: "not to"
    "Expected `#{inspect list}` #{to} have first element `#{inspect val}` but it has `#{result}`."
  end

end
