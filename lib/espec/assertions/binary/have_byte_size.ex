defmodule ESpec.Assertions.Binary.HaveByteSize do
  @moduledoc """
  Defines 'have_byte_size' assertion.

  it do: expect(binary).to have_byte_size(value)
  """
  use ESpec.Assertions.Interface

  defp match(binary, val) when is_binary(binary) do
    result = byte_size(binary)
    {result == val, result}
  end

  defp success_message(enum, val, _result, positive) do
    to = if positive, do: "has", else: "doesn't have"
    "`#{inspect enum}` #{to} `#{val}` byte(s)."
  end

  defp error_message(enum, val, result, positive) do
    to = if positive, do: "to", else: "not to"
    "Expected `#{inspect enum}` #{to} have `#{val}` byte(s) but it has `#{result}`."
  end
end
