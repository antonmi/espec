defmodule ESpec.Assertions.Eql do
  @moduledoc """
  Defines 'eql' (===) assertion.

  it do: expect(actual).to eql(expected)
  """
  use ESpec.Assertions.Interface

  defp match(subject, value) do
    result = subject === value
    {result, result}
  end

  defp success_message(subject, data, _result, positive) do
    to = if positive, do: "equals", else: "doesn't equal"
    "`#{inspect subject}` #{to} `#{inspect data}`."
  end

  defp error_message(subject, data, _result, positive) do
    to = if positive, do: "to", else: "not to"
    but = if positive, do: "doesn't", else: "does"
    m = "Expected `#{inspect subject}` #{to} equal (===) `#{inspect data}`, but it #{but}."
    if positive do
      {m, %{diff_fn: fn() -> ESpec.Diff.diff(subject, data) end}}
    else
      m
    end
  end
end
