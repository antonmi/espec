defmodule ESpec.DocTestTest.Mod4 do
  @doc """
    iex> String.to_atom((fn() -> 1 end).())
    ** (ArgumentError) argument error

    iex> 1 + "2"
    ** (ArithmeticError) bad argument in arithmetic expression

    iex> 1 + 1
    ** (ArithmeticError) bad argument in arithmetic expression
  """
  def f, do: :f
end |> ExUnit.TestHelpers.write_beam

defmodule ESpec.DocTest.ExceptionsSpec do
  use ESpec, async: true
  doctest ESpec.DocTestTest.Mod4, only: [f: 0]
end |> ExUnit.TestHelpers.write_beam

defmodule ESpec.Docs.ExceptionTest do
  use ExUnit.Case, async: true
  
  setup do
    examples = ESpec.DocTest.ExceptionsSpec.examples
    {:ok,
      ex1: Enum.at(examples, 0),
      ex2: Enum.at(examples, 1),
      ex3: Enum.at(examples, 2),
    }
  end

  test "ex1", context do
    ex = ESpec.ExampleRunner.run(context[:ex1])
    assert ex.status == :success
  end

  test "ex2", context do
    ex = ESpec.ExampleRunner.run(context[:ex2])
    assert ex.status == :success
  end

  test "ex3", context do
    ex = ESpec.ExampleRunner.run(context[:ex3])
    assert ex.status == :failure
  end
end
