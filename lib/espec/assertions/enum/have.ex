defmodule ESpec.Assertions.Enum.Have do

  use ESpec.Assertion

  defp match(enum, val) do
    result = Enum.member?(enum, val) 
    {result, result}
  end

  defp error_message(enum, val, result, positive) do
    to = if positive, do: "to", else: "to not"
    has = if result, do: "has", else: "has not"
    "Expected `#{inspect enum}` #{to} have `#{inspect val}`, but it #{has}."
  end

end
