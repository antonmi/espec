defmodule ESpec.Assertions.Enum.HaveCount do

  use ESpec.Assertions.Interface

  defp match(enum, val) do
    result = Enum.count(enum)
    {result == val, result}
  end

  defp success_message(enum, val, _result, positive) do
    to = if positive, do: "has", else: "doesn't have"
    "`#{inspect enum}` #{to} count `#{val}`."
  end

  defp error_message(enum, val, result, positive) do
    to = if positive, do: "to", else: "to not"
    "Expected `#{inspect enum}` #{to} have count `#{val}` but it has `#{result}` elements."
  end

end
