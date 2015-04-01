defmodule ESpec.Assertions.Enum.HaveMinBy do

  use ESpec.Assertion

  defp match(enum, [func, val]) do
    result = Enum.min_by(enum, func)
    {result == val, result}
  end

  defp error_message(enum, [func, val], result, positive) do
    to = if positive, do: "to be", else: "not to be"
    "Expected minimum value of `#{inspect enum}` using `#{inspect func}` #{to} `#{val}` but minimum is `#{result}`."
  end

end
