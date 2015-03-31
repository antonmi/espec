defmodule ESpec.Assertions.Enum.HaveAt do

  use ESpec.Assertion

  defp match(enum, [pos, val]) do
    result = Enum.at(enum, pos) 
    {result == val, result}
  end

  def error_message(enum, [pos, val], result, positive) do
    to = if positive, do: "to", else: "to not"
    "Expected `#{inspect enum}` #{to} have `#{inspect val}` on `#{inspect pos}` position, but it has `#{result}`."
  end

end
