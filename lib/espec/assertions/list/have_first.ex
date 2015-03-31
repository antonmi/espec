defmodule ESpec.Assertions.List.HaveFirst do

  use ESpec.Assertion

  defp match(list, val) do
    result = List.first(list)
    {result == val, result}
  end

  def error_message(list, val, result, positive) do
    to = if positive, do: "to", else: "to not"
    "Expected `#{inspect list}` #{to} have first element `#{val}` but it has `#{result}`."
  end

end
