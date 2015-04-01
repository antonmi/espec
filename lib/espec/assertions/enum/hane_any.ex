defmodule ESpec.Assertions.Enum.HaveAny do

  use ESpec.Assertion

  defp match(subject, func) do
    result = Enum.any?(subject, func)
    {result, result}
  end

  defp error_message(subject, func, result, positive) do
    to = if positive, do: "to", else: "to not"
    "Expected `#{inspect func}` #{to} return `true` for at least one element in `#{inspect subject}` but it returns `#{result}` for all."
  end

end
