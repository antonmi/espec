defmodule ExampleRunnerTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    before do
      {:ok, a: 10}
    end
    it do: "a = #{shared[:a]}"

    context "Context" do
      let :a, do: 20

      it do: "a = #{a}"
    end

    context "errors" do
      it do: expect(1).to eq(2)
      it do: UndefinedModule.run

      context "throw term inside it block" do
        it do: throw :some_term
      end
    end
  end

  setup_all do
    {:ok,
      ex1: Enum.at(SomeSpec.examples, 0),
      ex2: Enum.at(SomeSpec.examples, 1),
      ex3: Enum.at(SomeSpec.examples, 2),
      ex4: Enum.at(SomeSpec.examples, 3),
      ex5: Enum.at(SomeSpec.examples, 4)}
  end

  test "run success examples", context do
    example = ESpec.ExampleRunner.run(context[:ex1])
    assert(example.status == :success)
    example = ESpec.ExampleRunner.run(context[:ex2])
    assert(example.status == :success)
  end

  test "run failed example", context do
    example = ESpec.ExampleRunner.run(context[:ex3])
    assert example.status == :failure
    assert example.error.message == "Expected `1` to equals (==) `2`, but it doesn't."
  end

  test "run failed example with runtime error", context do
    example = ESpec.ExampleRunner.run(context[:ex4])
    assert example.status == :failure
    assert String.match?(example.error.message, ~r/undefined/)
  end

  test "run example which throws term", context do
    example = ESpec.ExampleRunner.run(context[:ex5])
    assert example.status == :failure
    assert String.match?(example.error.message, ~r/throw :some_term/)
  end
end
