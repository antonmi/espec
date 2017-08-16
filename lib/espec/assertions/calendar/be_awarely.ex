defmodule ESpec.Assertions.Calendar.BeAwarely do
  @moduledoc """
  Defines 'be_awarely' assertion.
  
  it do: expect(DateTime.from_naive!(~N[2017-01-01 10:00:00])).to be_awarely :after, DateTime.from_naive!(~N[2017-01-01 09:00:00])
  """
  use ESpec.Assertions.Interface
  require ESpec.Assertions.Calendar.Comparision, as: Comparision

  Comparision.match(DateTime)

  defp success_message(subject, [op, val], _result, positive) do
    "`#{inspect subject} is #{op} #{inspect val}` is #{positive}."
  end  

  defp error_message(subject, [op, val], _result, positive) do
    "Expected `#{inspect subject} is #{op} #{inspect val}` to be `#{positive}` but got `#{!positive}`."
  end
end
