defmodule ESpec.Assertions.Enum.BeEmpty do
  @moduledoc """
  Defines 'be_empty' assertion.

  it do: expect(collection).to be_empty
  it do: expect(string).to be_empty
  """
  use ESpec.Assertions.Interface

  defp match(string, _data) when is_bitstring(string) do
    result = String.length(string)
    {result == 0, result}
  end

  defp match(enum, _data) do
    result = Enum.count(enum)
    {result == 0, result}
  end

  defp success_message(enum, _data, _result, positive) do
    to = if positive, do: "is", else: "is not"
    "`#{inspect enum}` #{to} empty."
  end

  defp error_message(enum, _data, result, positive) do
    if positive do
      "Expected `#{inspect enum}` to be empty, but it has `#{result}` elements."
    else
      "Expected `#{inspect enum}` not to be empty, but it is."
    end
  end
end
