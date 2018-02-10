defmodule FilterTagsOnlyTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    it do: "without tag"
    it "example with tag", [some: :tag], do: "example with tag"

    context "context with tag", context_tag: true do
      it do: "example"
      it "example with tag", [inside_context: :tag], do: "example with tag"

      context "context inside context", cc_tag: "tag_cc" do
        it do: "example"
        it "example with tag", [ccc: :ccc_tag], do: "example with tag"
      end
    end
  end

  test "withot context, only with some tag" do
    examples = ESpec.SuiteRunner.filter(SomeSpec.examples, [only: "some:tag"])
    assert(Enum.count(examples) == 1)

    examples = ESpec.SuiteRunner.filter(SomeSpec.examples, [only: "some"])
    assert(Enum.count(examples) == 1)

    examples = ESpec.SuiteRunner.filter(SomeSpec.examples, [only: "wrong_tag"])
    assert(Enum.empty?(examples))
  end

  test "with context" do
    examples = ESpec.SuiteRunner.filter(SomeSpec.examples, [only: "context_tag:true"])
    assert(Enum.count(examples) == 4)

    examples = ESpec.SuiteRunner.filter(SomeSpec.examples, [only: "context_tag"])
    assert(Enum.count(examples) == 4)

    examples = ESpec.SuiteRunner.filter(SomeSpec.examples, [only: "inside_context"])
    assert(Enum.count(examples) == 1)
  end

  test "context inside context" do
    examples = ESpec.SuiteRunner.filter(SomeSpec.examples, [only: "cc_tag:tag_cc"])
    assert(Enum.count(examples) == 2)

    examples = ESpec.SuiteRunner.filter(SomeSpec.examples, [only: "cc_tag"])
    assert(Enum.count(examples) == 2)

    examples = ESpec.SuiteRunner.filter(SomeSpec.examples, [only: "ccc"])
    assert(Enum.count(examples) == 1)
  end
end
