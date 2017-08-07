defmodule ESpec.Assertions.Date.BeDate do
  @moduledoc """
  Defines 'be_date' assertion.

  it do: expect(date).to be_date
  """
  use ESpec.Assertions.Interface

  defp match(date, _val) do
    result = is_date?(date)
    {result, result}
  end

  defp success_message(date, _val, _result, positive) do
    to = if positive, do: "is", else: "is not"
    "`#{inspect date}` #{to} a Date."
  end

  defp error_message(date, _val, _result, positive) do
    to = if positive, do: "to", else: "not to"
    but = if positive, do: "it isn't", else: "it is"
    "Expected `#{inspect date}` #{to} be a Date but #{but}."
  end

  defp is_date?(%Date{}), do: true
  defp is_date?(_), do: false
end
