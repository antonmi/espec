defmodule ESpec.Assertions.Calendar.BeTimedBetween do
  @moduledoc """
  Defines 'be_between' assertion.
  
  it do: expect(~T[10:00:02]).to be_timed_between(~T[10:00:01], ~T[10:00:03])
  """
  use ESpec.Assertions.Interface
  require ESpec.Assertions.Calendar.Between, as: Between

  Between.match(Time)

  defp success_message(subject, [l, r], _result, positive) do
    to = if positive, do: "is", else: "is not"
    "`#{inspect subject}` #{to} between `#{inspect l}` and `#{inspect r}`."
  end 

  defp error_message(subject, [l, r], result, positive) do
    to = if positive, do: "to", else: "not to"
    but = if result, do: "it is", else: "it isn't"
    "Expected `#{inspect subject}` #{to} be between `#{inspect l}` and `#{inspect r}`, but #{but}."
  end
end
