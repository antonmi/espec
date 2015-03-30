defmodule ESpec.Assertions.ChangeFromTo do

  use ESpec.Assertion

  defp match(subject, [func, before, value]) do
    initial = func.() 
    subject.() 
    then = func.()
    result = (initial == before && then == value)
    {result, {then, initial, initial == before, then == value}}
  end

  defp error_message(subject, [func, before, value], {then, initial, true, false}, positive) do
    to = if positive, do: "to", else: "not to"
    "Expected `#{inspect subject}` #{to} change the value of `#{inspect func}` from `#{inspect before}` to `#{inspect value}`, but the value is `#{then}`."
  end

  defp error_message(subject, [func, before, value], {then, initial, false, _}, positive) do
    to = if positive, do: "to", else: "not to"
    "Expected `#{inspect subject}` #{to} change the value of `#{inspect func}` from `#{inspect before}` to `#{inspect value}`, but the initial value is `#{initial}`."
  end

end
