defmodule ESpec.DocTest.ExceptionsSpec do
  use ESpec, async: true
  doctest TestModules.Docs.DocTestModules.Mod4, only: [f: 0]
end
|> ExUnit.TestHelpers.write_beam()

defmodule ESpec.Docs.ExceptionTest do
  use ExUnit.Case, async: true

  setup do
    examples = ESpec.DocTest.ExceptionsSpec.examples()
    {:ok, ex1: Enum.at(examples, 0)}
  end

  test "ex1", context do
    ex = ESpec.ExampleRunner.run(context[:ex1])
    assert ex.status == :success
  end
end
