defmodule ESpec.Assertions.Calendar.BeAwarelyBetween do
  @moduledoc """
  Defines 'be_between' assertion.
  
  it do: expect(DateTime.from_naive!(~N[2017-01-02 10:00:00], "Etc/UTC")).to be_awarely_between(DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC"), DateTime.from_naive!(~N[2017-01-03 10:00:00], "Etc/UTC"))
  """
  use ESpec.Assertions.Interface
  require ESpec.Assertions.Calendar.Between, as: Between

  Between.match(DateTime)

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
