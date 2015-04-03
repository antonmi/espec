defmodule ESpec.Assertions.ChangeTo do
  use ESpec.Assertions.Interface

  defp match(subject, [func, value]) do
    initial = func.() 
    subject.() 
    then = func.()
    result = (initial != value && then == value)
    {result, {then, initial != value, then == value, initial == then}}
  end

  defp success_message(subject, [func, value], _result, positive) do
    to = if positive, do: "changes", else: "doesn't change"
    "`#{inspect subject}` #{to} the value of `#{inspect func}` to `#{inspect value}`."
  end 

  defp error_message(subject, [func, value], {then, true, false, false}, positive) do
    to = if positive, do: "to", else: "not to"
    "Expected `#{inspect subject}` #{to} change the value of `#{inspect func}` to `#{inspect value}`, but was changed to `#{inspect then}`"
  end

  defp error_message(subject, [func, value], {_then, true, false, true}, positive) do
    to = if positive, do: "to", else: "not to"
    "Expected `#{inspect subject}` #{to} change the value of `#{inspect func}` to `#{inspect value}`, but was not changed"
  end

  defp error_message(subject, [func, value], {_then, false, _, _}, positive) do
    to = if positive, do: "to", else: "not to"
    "Expected `#{inspect subject}` #{to} change the value of `#{inspect func}` to `#{inspect value}`, but the initial value is `#{inspect value}`"
  end

end
