defmodule ESpec.Assertions.Enum.HaveMin do

  use ESpec.Assertion

  defp match(enum, val) do
    result = Enum.min(enum)
    {result == val, result}
  end

  defp error_message(enum, val, result, positive) do
    to = if positive, do: "to be", else: "not to be"
    "Expected minimum value of `#{inspect enum}` #{to} `#{val}` but minimum is `#{result}`."
  end

end
