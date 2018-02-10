defmodule ESpec.Assertions.Match do
  @moduledoc """
  Defines 'match' (=~) assertion.
  
  it do: expect(actual).to match(expected)
  """
  use ESpec.Assertions.Interface

  defp match(subject, value) do
    result = subject =~ value
    {result, result}
  end

  defp success_message(subject, data, _result, positive) do
    to = if positive, do: "matches", else: "doesn't match"
    "`#{inspect subject}` #{to} (=~) `#{inspect data}`."
  end

  defp error_message(subject, data, _result, positive) do
    to = if positive, do: "to", else: "not to"
    but = if positive, do: "doesn't", else: "does"
    "Expected `#{inspect subject}` #{to} match (=~) `#{inspect data}`, but it #{but}."
  end
end
