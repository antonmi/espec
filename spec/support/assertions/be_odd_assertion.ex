defmodule BeOddAssertion do

  use ESpec.Assertions.Interface

  defp match(subject, []) do
    result = rem(subject, 2)
    if result == 1 do
      {true, result}
    else
      {false, result}
    end
  end

  defp success_message(subject, [], _result, positive) do
    to = if positive, do: "is", else: "is not"
    "`#{inspect subject} #{to} odd number."
  end  

  defp error_message(subject, [], result, positive) do
    to = if positive, do: "to", else: "not to"
    "Expected `#{inspect subject}` #{to} be the odd number, but the remainder is '#{result}'."
  end

end