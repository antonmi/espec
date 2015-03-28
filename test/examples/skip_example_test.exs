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
    results = ESpec.Runner.run |> Enum.map(&(&1.result))
    refute(Enum.any?(results, fn(r) -> r == "skipped" end))
  end
end