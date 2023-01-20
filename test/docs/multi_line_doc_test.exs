module =
  defmodule ESpec.DocTestTest.MulteLineDocSpec do
    use ESpec
    doctest TestModules.Docs.DocTestModules.Multiline
  end

ExUnit.TestHelpers.write_beam(module)

defmodule ESpec.MultiLineDocTest do
  use ExUnit.Case, async: true

  setup do
    examples = ESpec.DocTestTest.MulteLineDocSpec.examples()
    {:ok, ex1: Enum.at(examples, 0), ex2: Enum.at(examples, 1), ex3: Enum.at(examples, 2)}
  end

  test "ex1", context do
    ex = ESpec.ExampleRunner.run(context[:ex1])
    assert ex.description =~ "Doctest for Elixir.TestModules.Docs.DocTestModules.Multiline.f/0"
    assert ex.status == :success
    assert ex.result == "`[6, 4, 2, 1]` equals `[6, 4, 2, 1]`."
  end

  test "ex2", context do
    ex = ESpec.ExampleRunner.run(context[:ex2])
    assert ex.description =~ "Doctest for Elixir.TestModules.Docs.DocTestModules.Multiline.ff/0"
    assert ex.status == :success
    assert ex.result == "`3` equals `3`."
  end

  test "ex3", context do
    ex = ESpec.ExampleRunner.run(context[:ex3])
    assert ex.description =~ "Doctest for Elixir.TestModules.Docs.DocTestModules.Multiline.fff/0"
    assert ex.status == :success
    assert ex.result == "`10` equals `10`."
  end
end
