defmodule ESpec.Assertions.ChangeBy do
  @moduledoc """
  Defines 'change' assertion.

  it do: expect(function1).to change(function2, [by: value])
  """
  use ESpec.Assertions.Interface

  defp match(subject, [func, value]) do
    value = Keyword.get(value, :by)
    initial = func.()
    subject.()
    then = func.()

    result = (initial != value && then == value)
    {result, {then, initial != value, then == initial, then == initial + value}}
  end

  defp success_message(subject, [func, value], _result, positive) do
    to = if positive, do: "changes by", else: "doesn't change"
    "`#{inspect subject}` #{to} the value of `#{inspect func}` by `#{inspect Keyword.get(value, :by)}`."
  end

  defp error_message(subject, [func, value], {_then, true, true, _}, positive) do
    to = if positive, do: "to", else: "not to"
    "Expected `#{inspect subject}` #{to} change the value of `#{inspect func}` by `#{inspect Keyword.get(value, :by)}`, but was not changed"
  end

  defp error_message(subject, [func, value], {then, true, false, false}, positive) do
    to = if positive, do: "to", else: "not to"
    "Expected `#{inspect subject}` #{to} change the value of `#{inspect func}` by `#{inspect Keyword.get(value, :by)}`, but was changed by `#{inspect then}`"
  end
end
