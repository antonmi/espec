defmodule ESpec.Assertions.Accepted do

  use ESpec.Assertions.Interface

  defp match(subject, [func, args]) do
    pid = self()
    if Enum.any?(:meck.history(subject), fn(el) ->
        case el do
          {^pid, {^subject, ^func, ^args}, _return} -> true
          _ -> false
        end
      end) do
      {true, true}
    else
      {false, false}
    end
  end

  defp success_message(subject, [func, args], _result, positive) do
    to = if positive, do: "accepted", else: "didn't accept"
    "`#{inspect subject}` #{to} `#{inspect func}` with `#{inspect args}`."
  end  

  defp error_message(subject, [func, args], result, positive) do
    to = if positive, do: "to", else: "to not"
    but = if positive, do: "didn't", else: "did"
    "Expected `#{subject}` #{to} accept `#{inspect func}` with `#{inspect args}`, but it #{but}."
  end

end
