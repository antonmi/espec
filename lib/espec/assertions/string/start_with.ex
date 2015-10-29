defmodule ESpec.Assertions.String.StartWith do
  @moduledoc """
  Defines 'start_with' assertion.

  it do: expect(string).to start_with(value)
  """
  use ESpec.Assertions.Interface

  defp match(string, val) do
    result = String.starts_with?(string, val)
    if result do
      {result, val}
    else
      length = String.length(string)
      split_at = if length > 3, do: 3, else: length
      {first3, _} = String.split_at(string, split_at)
      {result, "#{first3}..."}
    end
  end

  defp success_message(string, val, _result, positive) do
    to = if positive, do: "starts", else: "doesn't start"
    "`#{inspect string}` #{to} with `#{inspect val}`."
  end

  defp error_message(string, val, result, positive) do
    to = if positive, do: "to", else: "not to"
    "Expected `#{inspect string}` #{to} start with `#{val}` but it starts with `#{result}`."
  end

end
