defmodule ESpec.Assertions.String.BeValidString do
  @moduledoc """
  Defines 'be_valid_string' assertion.

  it do: expect(string).to be_valid_string
  """
  use ESpec.Assertions.Interface

  defp match(string, _val) do
    result = String.valid?(string)
    {result, result}
  end

  defp success_message(string, _val, _result, positive) do
    to = if positive, do: "is", else: "is not"
    "`#{inspect string}` #{to} valid."
  end

  defp error_message(string, _val, _result, positive) do
    to = if positive, do: "to", else: "not to"
    but = if positive, do: "it isn't", else: "it is"
    "Expected `#{inspect string}` #{to} be valid but #{but}."
  end

end
