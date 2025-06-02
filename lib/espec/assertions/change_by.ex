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

    result = then == initial + value
    {result, {then, initial, then == initial}}
  end

  defp success_message(subject, [func, value], _result, positive) do
    to = if positive, do: "changes", else: "doesn't change"

    "`#{inspect(subject)}` #{to} the value of `#{inspect(func)}` by `#{inspect(Keyword.get(value, :by))}`."
  end

  defp error_message(subject, [func, value], {_then, _initial, true}, positive) do
    to = if positive, do: "to", else: "not to"

    {
      "Expected `#{inspect(subject)}` #{to} change the value of `#{inspect(func)}` by `#{inspect(Keyword.get(value, :by))}`, but was not changed",
      nil
    }
  end

  defp error_message(subject, [func, value], {then, initial, false}, positive) do
    to = if positive, do: "to", else: "not to"

    {
      "Expected `#{inspect(subject)}` #{to} change the value of `#{inspect(func)}` by `#{inspect(Keyword.get(value, :by))}`, but was changed by `#{inspect(then - initial)}`",
      nil
    }
  end
end
