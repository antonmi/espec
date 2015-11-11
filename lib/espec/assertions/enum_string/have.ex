defmodule ESpec.Assertions.EnumString.Have do
  @moduledoc """
  Defines 'have' assertion.

  it do: expect(enum).to have(value)

  it do: expect(string).to have(value)
  """
  use ESpec.Assertions.Interface

  defp match(enum, val) when is_binary(enum) do
    result = String.contains?(enum, val)
    {result, result}
  end

  defp match(enum, val) do
    result = Enum.member?(enum, val)
    {result, result}
  end

  defp success_message(enum, val, _result, positive) do
    to = if positive, do: "has", else: "doesn't have"
    "`#{inspect enum}` #{to} `#{inspect val}`."
  end

  defp error_message(enum, val, result, positive) do
    to = if positive, do: "to", else: "not to"
    has = if result, do: "has", else: "has not"
    "Expected `#{inspect enum}` #{to} have `#{inspect val}`, but it #{has}."
  end

end
