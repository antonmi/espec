defmodule ESpec.Assertions.EnumString.HaveAt do
  @moduledoc """
  Defines 'have_at' assertion.

  it do: expect(enum).to have_at(pos, value)

  it do: expect(string).to have_at(pos, value)
  """
  use ESpec.Assertions.Interface

  defp match(enum, [pos, val]) when is_binary(enum) do
    result = String.at(enum, pos)
    {result == val, result}
  end

  defp match(enum, [pos, val]) do
    result = Enum.at(enum, pos)
    {result == val, result}
  end

  defp success_message(enum, [pos, val], _result, positive) do
    to = if positive, do: "has", else: "doesn't have"
    "`#{inspect enum}` #{to} element `#{val}` at `#{inspect pos}` position."
  end

  defp error_message(enum, [pos, val], result, positive) do
    to = if positive, do: "to", else: "not to"
    "Expected `#{inspect enum}` #{to} have `#{inspect val}` at `#{inspect pos}` position, but it has `#{result}`."
  end

end
