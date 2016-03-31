defmodule LeakingLetTest do
  use ExUnit.Case

  defmodule SomeSpec do
    use ESpec

    describe "first" do
      let :a, do: 1

      it do: expect a |> to(eq 1)
    end

    describe "second" do
      it do: expect a |> to(eq 1)
    end

    it do: expect a |> to(eq 1)
  end

  setup_all do
    {:ok,
      ex1: Enum.at(SomeSpec.examples, 0),
      ex2: Enum.at(SomeSpec.examples, 1),
      ex3: Enum.at(SomeSpec.examples, 2)
    }
  end

  test "runs ex1 then ex2 and ex3", context do
    example = ESpec.ExampleRunner.run(context[:ex1])
    assert example.status == :success
    example = ESpec.ExampleRunner.run(context[:ex2])
    assert example.status == :failure
    assert example.error.message =~  "The let function `a/0` is not defined in the current scope!"
    example = ESpec.ExampleRunner.run(context[:ex3])
    assert example.status == :failure
  end
end
