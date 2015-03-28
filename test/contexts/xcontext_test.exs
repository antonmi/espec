defmodule XcontextTest do

  use ExUnit.Case

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

  test "runs only 1" do
    results = ESpec.Runner.run |> Enum.map(&(&1.result))
    refute(Enum.any?(results, fn(r) -> r == "skipped" end))
  end

end
