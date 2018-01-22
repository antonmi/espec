defmodule FilterTagsExcludeTest do
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
    examples = ESpec.SuiteRunner.filter(SomeSpec.examples(), exclude: "some:tag")
    assert(Enum.count(examples) == 5)

    examples = ESpec.SuiteRunner.filter(SomeSpec.examples(), exclude: "some")
    assert(Enum.count(examples) == 5)

    examples = ESpec.SuiteRunner.filter(SomeSpec.examples(), exclude: "wrong_tag")
    assert(Enum.count(examples) == 6)
  end

  test "with context" do
    examples = ESpec.SuiteRunner.filter(SomeSpec.examples(), exclude: "context_tag:true")
    assert(Enum.count(examples) == 2)

    examples = ESpec.SuiteRunner.filter(SomeSpec.examples(), exclude: "context_tag")
    assert(Enum.count(examples) == 2)

    examples = ESpec.SuiteRunner.filter(SomeSpec.examples(), exclude: "inside_context")
    assert(Enum.count(examples) == 5)
  end

  test "context inside context" do
    examples = ESpec.SuiteRunner.filter(SomeSpec.examples(), exclude: "cc_tag:tag_cc")
    assert(Enum.count(examples) == 4)

    examples = ESpec.SuiteRunner.filter(SomeSpec.examples(), exclude: "cc_tag")
    assert(Enum.count(examples) == 4)

    examples = ESpec.SuiteRunner.filter(SomeSpec.examples(), exclude: "ccc")
    assert(Enum.count(examples) == 5)
  end
end
