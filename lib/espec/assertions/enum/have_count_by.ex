defmodule ESpec.Assertions.Enum.HaveCountBy do
  @moduledoc """
  Defines 'have_count_by' assertion.

  it do: expect(collection).to have_count_by(func, value)
  """
  use ESpec.Assertions.Interface

  defp match(enum, [func, val]) do
    result = Enum.count(enum, func)
    {result == val, result}
  end

  defp success_message(enum, [func, val], _result, positive) do
    to = if positive, do: "is", else: "is not"
    "`#{inspect enum}` count_by `#{inspect func}` #{to} `#{val}`."
  end

  defp error_message(enum, [func, val], result, positive) do
    to = if positive, do: "to", else: "not to"
    "Expected `#{inspect enum}` #{to} have count_by `#{inspect func}` be equal to `#{val}` but it has `#{result}` elements."
  end
end
