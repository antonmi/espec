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
  end

  setup_all do
    {:ok,
      ex1: Enum.at(SomeSpec.examples, 0),
      ex2: Enum.at(SomeSpec.examples, 1),
    }
  end

  test "runs only 1" do
    [example] = ESpec.Runner.run
    assert(example.result == "Example")
  end
end