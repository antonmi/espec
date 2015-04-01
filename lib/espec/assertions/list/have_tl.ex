defmodule ESpec.Assertions.List.HaveTl do

  use ESpec.Assertion

  defp match(list, val) do
    result = tl(list)
    {result == val, result}
  end

  defp error_message(list, val, result, positive) do
    to = if positive, do: "to", else: "to not"
    "Expected `#{inspect list}` #{to} have `tl` `#{inspect val}` but it has `#{inspect result}`."
  end

end
