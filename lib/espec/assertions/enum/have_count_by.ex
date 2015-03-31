defmodule ESpec.Assertions.Enum.HaveCountBy do

  use ESpec.Assertion

  defp match(enum, [func, val]) do
    result = Enum.count(enum, func)
    {result == val, result}
  end

  def error_message(enum, [func, val], result, positive) do
    to = if positive, do: "to", else: "to not"
    "Expected `#{inspect enum}` #{to} have count_by `#{inspect func}` be equal to `#{val}` but it has `#{result}` elements."
  end


end