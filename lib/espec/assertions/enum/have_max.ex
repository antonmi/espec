defmodule ESpec.Assertions.Enum.HaveMax do

  use ESpec.Assertion

  defp match(enum, val) do
    result = Enum.max(enum)
    {result == val, result}
  end

  defp error_message(enum, val, result, positive) do
    to = if positive, do: "to be", else: "not to be"
    "Expected maximum value of `#{inspect enum}` #{to} `#{val}` but maximum is `#{result}`."
  end

end
