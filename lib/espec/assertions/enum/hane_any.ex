defmodule ESpec.Assertions.Enum.HaveAny do
  @moduledoc """
  Defines 'have_any' assertion.

  it do: expect(collection).to have_any(func)
  """
  use ESpec.Assertions.Interface

  defp match(enum, func) do
    result = Enum.any?(enum, func)
    {result, result}
  end

  defp success_message(enum, func, _result, positive) do
    if positive do
      "`#{inspect func}` returns `true` for at least one element in `#{inspect enum}`."
    else
      "`#{inspect func}` doesn't return `true` for any element in `#{inspect enum}`."
    end
  end

  defp error_message(enum, func, result, positive) do
    to = if positive, do: "to", else: "not to"
    "Expected `#{inspect func}` #{to} return `true` for at least one element in `#{inspect enum}` but it returns `#{result}` for all."
  end
end
