defmodule BeforeTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    before do: {:ok, a: 1}
    it do: "#{shared[:a]} is defined"

    context "Context" do
      before do: {:ok, a: 10, b: 2}
      it do: "#{shared[:a]} and #{shared[:b]} is defined"

      ESpec.Context.describe "Describe" do
        before do: {:ok, b: fn a -> a * 2 end}
        it do: "#{shared[:b].(10)} == 20"
      end
    end

    context "'shared is available" do
      before b: shared[:a] + 1
      it do: "b = #{shared[:b]}"
    end

    context "error or throw" do
      context "throw term" do
        before do: throw(:some_term)
        it do: true
      end

      context "fail " do
        before do: raise("Error")
        it do: true
      end
    end
  end

  setup_all do
    {:ok,
     ex1: Enum.at(SomeSpec.examples(), 0),
     ex2: Enum.at(SomeSpec.examples(), 1),
     ex3: Enum.at(SomeSpec.examples(), 2),
     ex4: Enum.at(SomeSpec.examples(), 3),
     ex5: Enum.at(SomeSpec.examples(), 4),
     ex6: Enum.at(SomeSpec.examples(), 5)}
  end

  test "run ex1", context do
    example = ESpec.ExampleRunner.run(context[:ex1])
    assert(example.result == "1 is defined")
  end

  test "run ex2", context do
    example = ESpec.ExampleRunner.run(context[:ex2])
    assert(example.result == "10 and 2 is defined")
  end

  test "run ex3", context do
    example = ESpec.ExampleRunner.run(context[:ex3])
    assert(example.result == "20 == 20")
  end

  test "run ex4", context do
    example = ESpec.ExampleRunner.run(context[:ex4])
    assert(example.result == "b = 2")
  end

  test "run example which throws term", context do
    example = ESpec.ExampleRunner.run(context[:ex5])
    assert example.status == :failure
    assert String.match?(example.error.message, ~r/throw :some_term/)
  end

  test "run example which raises error", context do
    example = ESpec.ExampleRunner.run(context[:ex6])
    assert example.status == :failure
    assert String.match?(example.error.message, ~r/\(RuntimeError\) Error/)
  end
end
