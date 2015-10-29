defmodule ESpec.Assertions.Enum.HaveAll do
  @moduledoc """
  Defines 'have_all' assertion.

  it do: expect(collection).to have_all(func)
  """
  use ESpec.Assertions.Interface

  defp match(enum, func) do
    result = Enum.all?(enum, func)
    {result, result}
  end

  defp success_message(enum, func, _result, positive) do
    to = if positive, do: "returns", else: "doesn't return"
    "`#{inspect func}` #{to} `true` for all elements in `#{inspect enum}`."
  end

  defp error_message(enum, func, _result, positive) do
    to = if positive, do: "to", else: "not to"
    returns = if positive, do: "`false` for some", else: "`true` for all"
    "Expected `#{inspect func}` #{to} return `true` for all elements in `#{inspect enum}`, but it returns #{returns}."
  end
end
