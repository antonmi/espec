defmodule ESpec.DocTestTest.Mod3 do
  @doc """
    iex> some_fun
    :some_fun
  """
  def some_fun, do: :some_fun
  
  @doc """
    iex> some_fun(1, 1)
    2
  """
  def some_fun(a, b), do: a + b

end |> ExUnit.TestHelpers.write_beam

defmodule ESpec.DocTestTest.ImportSpec do
  use ESpec
  doctest ESpec.DocTestTest.Mod3, import: true
end |> ExUnit.TestHelpers.write_beam


defmodule ESpec.DocTestImportTest do

  use ExUnit.Case, async: true

  setup do
    examples = ESpec.DocTestTest.ImportSpec.examples
    {:ok,
      ex1: Enum.at(examples, 0),
      ex2: Enum.at(examples, 1),
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

  
end