defmodule ESpec.Assertions.Calendar.BeNaively do
  @moduledoc """
  Defines 'be_naively' assertion.
  
  it do: expect(~N[2017-01-01 10:00:00]).to be_naively :after, ~N[2017-01-01 09:00:00]
  """
  use ESpec.Assertions.Interface
  require ESpec.Assertions.Calendar.Comparision, as: Comparision

  Comparision.match(NaiveDateTime)

  defp success_message(subject, [op, val], _result, positive) do
    "`#{inspect subject} is #{op} #{inspect val}` is #{positive}."
  end  

  defp error_message(subject, [op, val], _result, positive) do
    "Expected `#{inspect subject} is #{op} #{inspect val}` to be `#{positive}` but got `#{!positive}`."
  end
end
