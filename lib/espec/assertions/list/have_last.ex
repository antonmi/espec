defmodule ESpec.Assertions.List.HaveLast do

  use ESpec.Assertions.Interface

  defp match(list, val) do
    result = List.last(list)
    {result == val, result}
  end

	defp success_message(list, val, _result, positive) do
    to = if positive, do: "has", else: "doesn't have"
    "`#{inspect list}` #{to} last element `#{inspect val}`."
  end
	
  defp error_message(list, val, result, positive) do
    to = if positive, do: "to", else: "to not"
    "Expected `#{inspect list}` #{to} have last element `#{val}` but it has `#{result}`."
  end

end
