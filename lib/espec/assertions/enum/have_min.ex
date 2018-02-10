defmodule ESpec.Assertions.Enum.HaveMin do
  @moduledoc """
  Defines 'have_min' assertion.
  
  it do: expect(collection).to have_min(value)
  """
  use ESpec.Assertions.Interface

  defp match(enum, val) do
    result = Enum.min(enum)
    {result == val, result}
  end

  defp success_message(enum, val, _result, positive) do
    to = if positive, do: "is", else: "is not"
    "The minimum value of `#{inspect enum}` #{to} `#{val}`."
  end

  defp error_message(enum, val, result, positive) do
    to = if positive, do: "to be", else: "not to be"
    "Expected the minimum value of `#{inspect enum}` #{to} `#{val}` but the minimum is `#{result}`."
  end
end
