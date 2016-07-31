defmodule XcontextTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec
    let :a, do: 1

    it do: "Example"

    context "skipped", [skip: true] do
      it do: "skipped"
    end

    context [skip: true] do
      it do: "skipped"
      xit do: "skipped"
    end

    xcontext do
      it do: "skipped"
    end

    xcontext "skipped" do
      it do: "skipped"
    end    

    xcontext "skipped", [some: :opts] do
      it do: "skipped"
    end

    xdescribe do
      it do: "skipped"
    end

    xdescribe "skipped" do
      it do: "skipped"
    end    

    xdescribe "skipped", [some: :opts] do
      it do: "skipped"
    end

  end

  test "check success and pending" do
    results = ESpec.Runner.run_examples(SomeSpec.examples, true)
    assert(length(Enum.filter(results, &(&1.status == :success))) == 1)
    assert(length(Enum.filter(results, &(&1.status == :pending))) == 9)
  end
end
