defmodule ESpec.Assertions.Calendar.BeTimed do
  @moduledoc """
  Defines 'be_timed' assertion.
  
  it do: expect(~T[10:00:01]).to be_timed :after, ~T[09:59:00]
  """
  use ESpec.Assertions.Interface
  require ESpec.Assertions.Calendar.Comparision, as: Comparision

  Comparision.match(Time)

  defp success_message(subject, [op, val], _result, positive) do
    "`#{inspect subject} is #{op} #{inspect val}` is #{positive}."
  end  

  defp error_message(subject, [op, val], _result, positive) do
    "Expected `#{inspect subject} is #{op} #{inspect val}` to be `#{positive}` but got `#{!positive}`."
  end
end
