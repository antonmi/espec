defmodule ESpec.Assertions.Enum.HaveCount do

  use ESpec.Assertion

  defp match(enum, val) do
    result = Enum.count(enum)
    {result == val, result}
  end

  defp error_message(enum, val, result, positive) do
    to = if positive, do: "to", else: "to not"
    "Expected `#{inspect enum}` #{to} have count `#{val}` but it has `#{result}` elements."
  end

end
