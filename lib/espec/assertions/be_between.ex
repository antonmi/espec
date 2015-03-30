defmodule ESpec.Assertions.BeBetween do

  use ESpec.Assertion

  defp match(subject, [l, r]) do
    result = subject >= l && subject <= r
    {result, result}
  end

  defp error_message(subject, [l, r], result, positive) do
    to = if positive, do: "to", else: "not to"
    but = if result, do: "it is", else: "it is not"
    "Expected `#{inspect subject}` #{to} be between `#{inspect l}` and `#{inspect r}`, but #{but}."
  end

end
