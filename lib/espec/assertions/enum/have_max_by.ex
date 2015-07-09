defmodule ESpec.Assertions.Enum.HaveMaxBy do
  @moduledoc """
  Defines 'have_max_by' assertion.
  
  it do: expect(collection).to have_max_by(func, value)
  """
  use ESpec.Assertions.Interface

  defp match(enum, [func, val]) do
    result = Enum.max_by(enum, func)
    {result == val, result}
  end

  defp success_message(enum, [func, val], _result, positive) do
    to = if positive, do: "is", else: "is not"
    "The maximum value of `#{inspect enum}` using `#{inspect func}` #{to} `#{val}`."
  end

  defp error_message(enum, [func, val], result, positive) do
    to = if positive, do: "to be", else: "not to be"
    "Expected the maximum value of `#{inspect enum}` using `#{inspect func}` #{to} `#{val}` but the maximum is `#{result}`."
  end
end
