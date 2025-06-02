defmodule ESpec.Assertions.String.BeBlank do
  @moduledoc """
  Defines 'be_blank' assertion.

  it do: expect(string).to be_blank
  """
  use ESpec.Assertions.Interface

  defp match(string, _val) do
    result = String.length(string) == 0
    {result, result}
  end

  defp success_message(string, _val, _result, positive) do
    to = if positive, do: "is", else: "is not"
    "`#{inspect(string)}` #{to} blank."
  end

  defp error_message(string, _val, _result, positive) do
    to = if positive, do: "to", else: "not to"
    but = if positive, do: "it isn't", else: "it is"
    {"Expected `#{inspect(string)}` #{to} be blank but #{but}.", nil}
  end
end
