defmodule SkipExampleTest do

  use ExUnit.Case

  defmodule SomeSpec do
    use ESpec

    it do: "Example"
    it "skipped", [skip: true], do: "skipped"

    xit do: "skipped"
    xit "skipped", do: "skipped"
    xit "skipped", [some: :option], do: "skipped"

    xexample do: "skipped"
    xexample "skipped", do: "skipped"
    xexample "skipped", [some: :option], do: "skipped"

    xspecify do: "skipped"
    xspecify "skipped", do: "skipped"
    xspecify "skipped", [some: :option], do: "skipped"
  end

  test "runs only 1" do
    results = ESpec.Runner.run_examples(SomeSpec.examples)
    assert(length(Enum.filter(results, &(&1.status == :success))) == 1)
    assert(length(Enum.filter(results, &(&1.status == :pending))) == 10)
  end
end