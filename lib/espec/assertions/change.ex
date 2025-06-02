defmodule ESpec.Assertions.Change do
  @moduledoc """
  Defines 'change' assertion.

  it do: expect(function1).to change(function2, to)
  """
  use ESpec.Assertions.Interface

  defp match(subject, [func]) do
    initial = func.()
    subject.()
    then = func.()
    result = initial != then
    {result, result}
  end

  defp success_message(subject, [func], _result, positive) do
    to = if positive, do: "changes", else: "doesn't change"
    "`#{inspect(subject)}` #{to} the value of `#{inspect(func)}`."
  end

  defp error_message(subject, [func], _result, positive) do
    to = if positive, do: "to", else: "not to"
    but = if positive, do: "didn't change", else: "changed"
    {
      "Expected `#{inspect(subject)}` #{to} change the value of `#{inspect(func)}`, but it #{but}.",
      nil
    }
  end
end
