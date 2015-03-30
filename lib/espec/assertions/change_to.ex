defmodule ESpec.Assertions.ChangeTo do

  use ESpec.Assertion

  defp match(subject, [func, value]) do
    initial = func.() 
    subject.() 
    then = func.()
    result = (initial != value && then == value)
    {result, {then, initial != value, then == value, initial == then}}
  end

  defp error_message(subject, [func, value], {then, true, false, false}, positive) do
    to = if positive, do: "to", else: "not to"
    "Expected `#{inspect subject}` #{to} change the value of `#{inspect func}` to `#{inspect value}`, but was changed to `#{inspect then}`"
  end

  defp error_message(subject, [func, value], {then, true, false, true}, positive) do
    to = if positive, do: "to", else: "not to"
    "Expected `#{inspect subject}` #{to} change the value of `#{inspect func}` to `#{inspect value}`, but was not changed"
  end

  defp error_message(subject, [func, value], {then, false, _, _}, positive) do
    to = if positive, do: "to", else: "not to"
    "Expected `#{inspect subject}` #{to} change the value of `#{inspect func}` to `#{inspect value}`, but the initial value is `#{inspect value}`"
  end

end
