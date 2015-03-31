defmodule ESpec.Assertions.List.HaveHd do

  use ESpec.Assertion

  defp match(list, val) do
    result = hd(list)
    {result == val, result}
  end

  def error_message(list, val, result, positive) do
    to = if positive, do: "to", else: "to not"
    "Expected `#{inspect list}` #{to} have `hd` `#{val}` but it has `#{result}`."
  end

end
