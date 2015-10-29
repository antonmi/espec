defmodule ESpec.Assertions.EnumString.HaveCount do
  @moduledoc """
  Defines 'have_count' assertion.

  it do: expect(enum).to have_count(value)

  it do: expect(string).to have_count(value)
  """
  use ESpec.Assertions.Interface

  defp match(enum, val) when is_binary(enum) do
    result = String.length(enum)
    {result == val, result}
  end

  defp match(enum, val) do
    result = Enum.count(enum)
    {result == val, result}
  end

  defp success_message(enum, val, _result, positive) do
    to = if positive, do: "has", else: "doesn't have"
    "`#{inspect enum}` #{to} `#{val}` elements."
  end

  defp error_message(enum, val, result, positive) do
    to = if positive, do: "to", else: "not to"
    "Expected `#{inspect enum}` #{to} have `#{val}` elements but it has `#{result}`."
  end

end
