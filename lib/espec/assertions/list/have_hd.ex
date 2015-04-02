defmodule ESpec.Assertions.List.HaveHd do

  use ESpec.Assertion

  defp match(list, val) do
    result = hd(list)
    {result == val, result}
  end

  defp success_message(list, val, _result, positive) do
    to = if positive, do: "has", else: "doesn't have"
    "`#{inspect list}` #{to} `hd` == `#{inspect val}`."
  end 

  defp error_message(list, val, result, positive) do
    to = if positive, do: "to", else: "to not"
    "Expected `#{inspect list}` #{to} have `hd` `#{val}` but it has `#{result}`."
  end

end
