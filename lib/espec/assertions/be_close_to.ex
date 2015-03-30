defmodule ESpec.Assertions.BeCloseTo do

  use ESpec.Assertion

  defp match(subject, data) do
    [value, delta] = data
    result = abs(subject-value) <= delta
    {result, result}
  end

  defp error_message(subject, data, result, positive) do
    to = if positive, do: "to", else: "not to"
    but = if result, do: "it does", else: "it doesn't"
    [value, delta] = data
    "Expected `#{inspect subject}` #{to} be close to `#{inspect value}` with delta `#{inspect delta}`, but #{but}."
  end
 
end
