defmodule LineFilterTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    context "tests" do
      it "example with tag", do: "example with tag"

      context "context with tag" do
        it do: "example"
        it "example with tag", do: "example with tag"

        context "context inside context" do
          it do: "example"
          it "example with tag", do: "example with tag"
        end
      end
    end
  end

  test "runs specs within block at line 7" do
    ESpec.Configuration.add(
      file_opts: [{Path.expand("./test/examples/line_filter_test.exs"), [line: 7]}]
    )

    examples = ESpec.SuiteRunner.filter(SomeSpec.examples(), ESpec.Configuration.all())
    assert(Enum.count(examples) == 5)
  end

  test "runs specs within block at line 8" do
    ESpec.Configuration.add(
      file_opts: [{Path.expand("./test/examples/line_filter_test.exs"), [line: 8]}]
    )

    examples = ESpec.SuiteRunner.filter(SomeSpec.examples(), ESpec.Configuration.all())
    assert(Enum.count(examples) == 1)
  end

  test "runs specs within block at line 10" do
    ESpec.Configuration.add(
      file_opts: [{Path.expand("./test/examples/line_filter_test.exs"), [line: 10]}]
    )

    examples = ESpec.SuiteRunner.filter(SomeSpec.examples(), ESpec.Configuration.all())
    assert(Enum.count(examples) == 4)
  end

  test "runs specs within block at line 14" do
    ESpec.Configuration.add(
      file_opts: [{Path.expand("./test/examples/line_filter_test.exs"), [line: 14]}]
    )

    examples = ESpec.SuiteRunner.filter(SomeSpec.examples(), ESpec.Configuration.all())
    assert(Enum.count(examples) == 2)
  end
end
