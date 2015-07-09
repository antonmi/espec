defmodule ESpec.Assertions.BeCloseTo do
  @moduledoc """
  Defines 'be_close_to' assertion.
  
  it do: expect(2).to be_close_to(1, 3)
  """
  use ESpec.Assertions.Interface

  defp match(subject, data) do
    [value, delta] = data
    result = abs(subject-value) <= delta
    {result, result}
  end

  defp success_message(subject, [value, delta], _result, positive) do
    to = if positive, do: "is", else: "is not"
    "`#{inspect subject}` #{to} close to `#{inspect value}` with delta `#{inspect delta}`."
  end 
  
  defp error_message(subject, [value, delta], result, positive) do
    to = if positive, do: "to", else: "not to"
    but = if result, do: "it is", else: "it isn't"
    "Expected `#{inspect subject}` #{to} be close to `#{inspect value}` with delta `#{inspect delta}`, but #{but}."
  end
 
end
