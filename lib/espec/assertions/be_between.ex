defmodule ESpec.Assertions.BeBetween do
  @moduledoc """
  Defines 'be_between' assertion.
  
  it do: expect(2).to be_between(1, 3)
  """
  use ESpec.Assertions.Interface

  defp match(subject, [l, r]) do
    result = subject >= l && subject <= r
    {result, result}
  end

  defp success_message(subject, [l, r], _result, positive) do
    to = if positive, do: "is", else: "is not"
    "`#{inspect subject}` #{to} be between `#{inspect l}` and `#{inspect r}`."
  end 

  defp error_message(subject, [l, r], result, positive) do
    to = if positive, do: "to", else: "not to"
    but = if result, do: "it is", else: "it isn't"
    "Expected `#{inspect subject}` #{to} be between `#{inspect l}` and `#{inspect r}`, but #{but}."
  end
end
