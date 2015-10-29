defmodule ESpec.Assertions.BeType do
  @moduledoc """
  Defines 'be_type' assertion.

  it do: expect("abc").to be_binary
  """
  use ESpec.Assertions.Interface

  defp match(subject, :null) do
    result = is_nil(subject)
    {result, result}
  end

  defp match(subject, [:function, arity]) do
    result = is_function(subject, arity)
    {result, result}
  end

  defp match(%{__struct__: actual}, [:struct, expected]) when actual == expected, do: {true, true}
  defp match(_, [:struct, _expected]), do: {false, false}

  defp match(%{__struct__: _}, :struct), do: {true, true}
  defp match(_, :struct), do: {false, false}

  defp match(subject, type) do
    result = apply(Kernel, :"is_#{type}", [subject])
    {result, result}
  end

  defp success_message(subject, :null, _result, positive) do
    to = if positive, do: "is", else: "is not"
    "`#{inspect subject}` #{to} nil."
  end

  defp success_message(subject, [:function, arity], _result, positive) do
    to = if positive, do: "is", else: "is not"
    "`#{inspect subject}` #{to} `function` with arity `#{arity}`."
  end

  defp success_message(subject, [:struct, name], _result, positive) do
    to = if positive, do: "is", else: "is not"
    "`#{inspect subject}` #{to} struct named `#{name}`"
  end

  defp success_message(subject, type, _result, positive) do
    to = if positive, do: "is", else: "is not"
    "`#{inspect subject}` #{to} is `#{type}`."
  end

  defp error_message(subject, :null, _result, positive) do
    to = if positive, do: "to", else: "not to"
    but = if positive, do: "isn't", else: "is"
    "Expected `#{inspect subject}` #{to} be nil but it #{but}."
  end

  defp error_message(subject, [:function, arity], _result, positive) do
    to = if positive, do: "to", else: "not to"
    but = if positive, do: "isn't", else: "is"
    "Expected `#{inspect subject}` #{to} be function with arity `#{arity}` but it #{but}."
  end

  defp error_message(subject, [:struct, name], _result, positive) do
    to = if positive, do: "to", else: "not to"
    but = if positive, do: "isn't", else: "is"
    "Expected `#{inspect subject}` #{to} be struct with name `#{name}` but it #{but}"
  end

  defp error_message(subject, type, _result, positive) do
    to = if positive, do: "to", else: "not to"
    but = if positive, do: "isn't", else: "is"
    "Expected `#{inspect subject}` #{to} be `#{type}` but it #{but}."
  end
end
