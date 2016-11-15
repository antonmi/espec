defmodule StringFilterTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    it "some test", do: "test"
    context "some context" do
      it "another test", do: "example"
    end
  end

  test "matches example description" do
    examples = ESpec.SuiteRunner.filter(SomeSpec.examples, [string: "some test"])
    assert(Enum.count(examples) == 1)

    examples = ESpec.SuiteRunner.filter(SomeSpec.examples, [string: "another test"])
    assert(Enum.count(examples) == 1)

    examples = ESpec.SuiteRunner.filter(SomeSpec.examples, [string: "test"])
    assert(Enum.count(examples) == 2)

    examples = ESpec.SuiteRunner.filter(SomeSpec.examples, [string: "wrong"])
    assert(Enum.count(examples) == 0)
  end

  test "matches context description" do
    examples = ESpec.SuiteRunner.filter(SomeSpec.examples, [string: "SomeSpec"])
    assert(Enum.count(examples) == 2)

    examples = ESpec.SuiteRunner.filter(SomeSpec.examples, [string: "some context"])
    assert(Enum.count(examples) == 1)

    examples = ESpec.SuiteRunner.filter(SomeSpec.examples, [string: "wrong"])
    assert(Enum.count(examples) == 0)
  end

end
