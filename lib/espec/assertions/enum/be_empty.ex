defmodule ESpec.Assertions.Enum.BeEmpty do

  use ESpec.Assertion

  defp match(enum, data) do
    result = Enum.count(enum) 
    {result == 0, result}
  end

  defp success_message(enum, val, _result, positive) do
    to = if positive, do: "is", else: "is not"
    "`#{inspect enum}` #{to} empty."
  end

  defp error_message(enum, data, result, positive) do
    if positive do
      "Expected `#{inspect enum}` to be empty, but it has `#{result}` elements."
    else
      "Expected `#{inspect enum}` to not be empty, but it is."
    end
  end

end
