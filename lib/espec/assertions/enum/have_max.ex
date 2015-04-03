defmodule ESpec.Assertions.Enum.HaveMax do

  use ESpec.Assertions.Interface

  defp match(enum, val) do
    result = Enum.max(enum)
    {result == val, result}
  end

  defp success_message(enum, val, _result, positive) do
    to = if positive, do: "is", else: "is not"
    "The maximum value of `#{inspect enum}` #{to} `#{val}`."
  end

  defp error_message(enum, val, result, positive) do
    to = if positive, do: "to be", else: "not to be"
    "Expected the maximum value of `#{inspect enum}` #{to} `#{val}` but the maximum is `#{result}`."
  end

end
