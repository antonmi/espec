defmodule BeDivisorOfAssertion do
  use ESpec.Assertions.Interface

  defp match(subject, number) do
    result = rem(number, subject)
    {result == 0, result}
  end

  defp success_message(subject, number, _result, positive) do
    to = if positive, do: "is", else: "is not"
    "`#{inspect(subject)}` #{to} the divisor of #{number}."
  end

  defp error_message(subject, number, result, positive) do
    to = if positive, do: "to", else: "not to"

    "Expected `#{inspect(subject)}` #{to} be the divisor of `#{number}`, but the remainder is '#{result}'."
  end
end
