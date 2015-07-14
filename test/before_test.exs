defmodule BeforeTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    before do: {:ok, a: 1}
    it do: "#{__[:a]} is defined"

    context "Context" do
      before do: {:ok, a: 10, b: 2}
      it do: "#{__[:a]} and #{__[:b]} is defined"

      describe "Describe" do
        before do: {:ok, b: fn(a) -> a*2 end}
        it do: "#{__[:b].(10)} == 20"
      end
    end

    context "__ is available" do
      before do: {:ok, b: __[:a] + 1 }
      it do: "b = #{__[:b]}"
    end
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
end
