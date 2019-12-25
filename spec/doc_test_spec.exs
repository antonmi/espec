defmodule ESpec.DocTestTest.Mod1 do
  @moduledoc """
    iex> 2 + 2
    4
  """

  @doc """
    iex> Enum.map [1, 2, 3], fn(x) ->
    ...>   x * 2
    ...> end
    [2,4,6]

    iex> 2 + 2
    4

    iex> Enum.into([a: 10, b: 20], Map.new)
    %{a: 10, b: 20}

    iex> ESpec.DocTestTest.Mod1.f
    :f

    iex> a = 1
    iex> 1 + a
    2
    iex> 2 + a
    3

    iex> dict = Enum.into([a: 10, b: 20], Map.new)
    iex> Map.get(dict, :a)
    10
  """
  def f, do: :f
end
|> ESpec.TestHelpers.write_beam()

defmodule ESpec.DocTestTest.ExceptionInterpolation do
  @moduledoc """
    iex> raise ArgumentError, message: ~S'Check for "string"'
    ** (ArgumentError) Check for "string"

    iex> raise ArgumentError, message: "Check for 'string'"
    ** (ArgumentError) Check for 'string'

    iex> raise ArgumentError, message: "Check for |string|"
    ** (ArgumentError) Check for |string|

    iex> raise ArgumentError, message: "Check for /string/"
    ** (ArgumentError) Check for /string/

    iex> raise ArgumentError, message: "Check for (string)"
    ** (ArgumentError) Check for (string)

    iex> raise ArgumentError, message: "Check for [string]"
    ** (ArgumentError) Check for [string]

    iex> raise ArgumentError, message: "Check for {string}"
    ** (ArgumentError) Check for {string}

    iex> raise ArgumentError, message: "Check for <string>"
    ** (ArgumentError) Check for <string>

    iex> raise ArgumentError, message: "Check for a very, very, very, very, very, very, very, very, very, very, very, very, very, very, very long string"
    ** (ArgumentError) Check for a very, very, very, very, very, very, very, very, very, very, very, very, very, very, very long string
  """
end
|> ESpec.TestHelpers.write_beam()

defmodule DocTestSpec do
  use ESpec

  doctest ESpec.DocTestTest.Mod1
  doctest ESpec.DocTestTest.ExceptionInterpolation

  it do: expect(ESpec.DocTestTest.Mod1.f() |> to(eq :f))
end
