defmodule ESpec.Assertions.BeType do

  use ESpec.Assertion

  defp match(subject, :null) do
    result = is_nil(subject)
    {result, result}
  end

  defp match(subject, [:function, arity]) do
    result = is_function(subject, arity)
    {result, result}
  end

  defp match(subject, type) do
    result = apply(Kernel, :"is_#{type}", [subject])
    {result, result}
  end

  defp error_message(subject, :null, result, positive) do
  	to = if positive, do: "to", else: "to not"
  	but = if positive, do: "isn't", else: "is"
    "Expected `#{inspect subject}` #{to} be nil but it #{but}."
  end

	defp error_message(subject, [:function, arity], result, positive) do
		to = if positive, do: "to", else: "to not"
  	but = if positive, do: "isn't", else: "is"
    "Expected `#{inspect subject}` #{to} be function with arity `#{arity}` but it #{but}."
  end

  defp error_message(subject, type, result, positive) do
  	to = if positive, do: "to", else: "to not"
  	but = if positive, do: "isn't", else: "is"
    "Expected `#{inspect subject}` to be `#{type}` but it is not."
  end

end