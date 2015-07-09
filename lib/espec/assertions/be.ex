defmodule ESpec.Assertions.Be do
  @moduledoc """
  Defines 'be' assertion.
  
  it do: expect(2).to be :>, 1
  """
  use ESpec.Assertions.Interface

  defp match(subject, [op, val]) do
    result = apply(Kernel, op, [subject, val])
    {result, result}
  end

  defp success_message(subject, [op, val], _result, positive) do
    to = if positive, do: "is true", else: "is false"
    "`#{inspect subject} #{op} #{inspect val}` #{to}."
  end  

  defp error_message(subject, [op, val], _result, positive) do
    "Expected `#{inspect subject} #{op} #{inspect val}` to be `#{positive}` but got `#{!positive}`."
  end
end
