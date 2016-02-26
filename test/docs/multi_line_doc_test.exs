defmodule ESpec.DocTestTest.Multiline do
  @doc """
  iex> a = Enum.map [1, 2, 3], fn(x) ->
  ...>   x * 2
  ...> end
  iex> b = [1 | a]
  iex> Enum.reverse(b)
  [6,4,2,1]
  """
  def f, do: :f

  @doc """
    iex> a = 1
    iex> 2 + a
    3
  """
  def ff, do: :ff

  @doc """
    iex> dict = Enum.into([a: 10, b: 20], Map.new)
    iex> Map.get(dict, :a)
    10
  """
  def fff, do: :fff
end |> ExUnit.TestHelpers.write_beam

defmodule ESpec.DocTestTest.MulteLineDocSpec do
  use ESpec
  doctest ESpec.DocTestTest.Multiline
end |> ExUnit.TestHelpers.write_beam


defmodule ESpec.MultiLineDocTest do
  use ExUnit.Case, async: true

  doctest ESpec.DocTestTest.Multiline

  setup do
    examples = ESpec.DocTestTest.MulteLineDocSpec.examples
    {:ok,
      ex1: Enum.at(examples, 0),
      ex2: Enum.at(examples, 1),
      ex3: Enum.at(examples, 2),
    }
  end

  test "ex1", context do
    ex = ESpec.ExampleRunner.run(context[:ex1])
    assert ex.description =~ "Doctest for Elixir.ESpec.DocTestTest.Multiline.f/0"
    assert ex.status == :success
    assert ex.result == "`[6, 4, 2, 1]` equals `[6, 4, 2, 1]`."
  end

  test "ex2", context do
    ex = ESpec.ExampleRunner.run(context[:ex2])
    assert ex.description =~ "Doctest for Elixir.ESpec.DocTestTest.Multiline.ff/0"
    assert ex.status == :success
    assert ex.result == "`3` equals `3`."
  end

  test "ex3", context do
    ex = ESpec.ExampleRunner.run(context[:ex3])
    assert ex.description =~ "Doctest for Elixir.ESpec.DocTestTest.Multiline.fff/0"
    assert ex.status == :success
    assert ex.result == "`10` equals `10`."
  end
end
