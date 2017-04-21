defmodule ESpec.Assertions.Eq do
  @moduledoc """
  Defines 'eq' (==) assertion.

  it do: expect(actual).to eq(expected)
  """
  use ESpec.Assertions.Interface

  defp match(subject, value) do
    result = subject == value
    {result, result}
  end

  defp success_message(subject, data, _result, positive) do
    to = if positive, do: "equals", else: "doesn't equal"
    "`#{inspect subject}` #{to} `#{inspect data}`."
  end

  defp error_message(subject, data, _result, positive) do
    expected = if positive, do: "Expected", else: "Didn't expect"

    if positive do
      {"#{expected} (==) `#{inspect data}`, but got: `#{inspect subject}`",
        %{diff_fn: fn() -> ESpec.Diff.diff(subject, data) end}}
    else
      "#{expected} (==) `#{inspect data}`, but got it"
    end
  end
end
