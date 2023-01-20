defmodule ESpec.DocTestTest.ImportSpec do
  use ESpec
  doctest TestModules.Docs.DocTestModules.Mod3, import: true
end
|> ExUnit.TestHelpers.write_beam()

defmodule ESpec.Docs.ImportOptionTest do
  use ExUnit.Case, async: true

  setup do
    examples = ESpec.DocTestTest.ImportSpec.examples()
    {:ok, ex1: Enum.at(examples, 0), ex2: Enum.at(examples, 1)}
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
