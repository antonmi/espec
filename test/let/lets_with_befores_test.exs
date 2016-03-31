defmodule LetsWithBeforesTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    before do: {:ok, a: 1}
    it do: shared.a |> should(eq 1)

    let :b, do: shared.a + 1
    it do: b |> should(eq 2)

    let! :c, do: b + 1
    it do: c |> should(eq 3)

    before do:  {:ok, d: c + 1}
    it do: shared.d |> should(eq 4)
  end

  setup_all do
    {:ok,
      ex1: Enum.at(SomeSpec.examples, 0),
      ex2: Enum.at(SomeSpec.examples, 1),
      ex3: Enum.at(SomeSpec.examples, 2),
      ex4: Enum.at(SomeSpec.examples, 3)
    }
  end

  test "run ex1", context do
    example = ESpec.ExampleRunner.run(context[:ex1])
    assert(example.status == :success)
  end

  test "run ex2", context do
    example = ESpec.ExampleRunner.run(context[:ex2])
    assert(example.status == :success)
  end

  test "run ex3", context do
    example = ESpec.ExampleRunner.run(context[:ex3])
    assert(example.status == :success)
  end

   test "run ex5", context do
    example = ESpec.ExampleRunner.run(context[:ex4])
    assert(example.status == :success)
  end
end
