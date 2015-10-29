defmodule ESpec.Assertions.String.EndWith do
  @moduledoc """
  Defines 'end_with' assertion.

  it do: expect(string).to end_with(value)
  """
  use ESpec.Assertions.Interface

  defp match(string, val) do
    result = String.ends_with?(string, val)
    if result do
      {result, val}
    else
      length = String.length(string)
      split_at = if length > 3, do: length - 3, else: 0
      {_, last3} = String.split_at(string, split_at)
      {result, "...#{last3}"}
    end
  end

  defp success_message(string, val, _result, positive) do
    to = if positive, do: "ends", else: "doesn't end"
    "`#{inspect string}` #{to} with `#{inspect val}`."
  end

  defp error_message(string, val, result, positive) do
    to = if positive, do: "to", else: "not to"
    "Expected `#{inspect string}` #{to} end with `#{val}` but it ends with `#{result}`."
  end

end
