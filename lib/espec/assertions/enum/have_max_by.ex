defmodule ESpec.Assertions.Enum.HaveMaxBy do

  use ESpec.Assertion

  defp match(enum, [func, val]) do
    result = Enum.max_by(enum, func)
    {result == val, result}
  end

  def error_message(enum, [func, val], result, positive) do
    to = if positive, do: "to be", else: "not to be"
    "Expected maximum value of `#{inspect enum}` using `#{inspect func}` #{to} `#{val}` but maximum is `#{result}`."
  end

end
