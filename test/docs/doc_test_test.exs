defmodule ESpec.DocTestTest.Mod1 do
  @doc """
    iex> Enum.map [1, 2, 3], fn(x) ->
    ...>   x * 2
    ...> end
    [2,4,6]

    iex> 2 + 2
    5
  """
  def f, do: :f
end |> ExUnit.TestHelpers.write_beam

defmodule ESpec.DocTestTest.SomeSpec do
  use ESpec
  doctest ESpec.DocTestTest.Mod1
end |> ExUnit.TestHelpers.write_beam


defmodule ESpec.DocTestTest do

  use ExUnit.Case, async: true

  setup do
    examples = ESpec.Runner.run_examples(ESpec.DocTestTest.SomeSpec.examples)
    {:ok,
      ex1: Enum.at(examples, 0),
      ex2: Enum.at(examples, 1),
    }
  end

  test "ex1", context do
    IO.inspect context[:ex1]
  end

  test "ex2", context do
    IO.inspect context[:ex2]
  end


end