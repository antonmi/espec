defmodule ESpec.Assertions.Enum.HaveAll do

  use ESpec.Assertion

  defp match(enum, func) do
    result = Enum.all?(enum, func)
    {result, result}
  end

  def error_message(enum, func, result, positive) do
    to = if positive, do: "to", else: "to not"
    returns = if positive, do: "`false` for some", else: "`true` for all"
    "Expected `#{inspect func}` #{to} return `true` for all elements in `#{inspect enum}`, but it returns #{returns}."
  end


end