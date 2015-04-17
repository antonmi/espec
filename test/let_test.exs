defmodule LetTest do

  use ExUnit.Case

  defmodule SomeSpec do
    use ESpec

    let :a, do: 10
    it do: "a = #{a}"

    context "Context" do
      let :a, do: 20
      let :f, do: fn(x) -> x*2 end

      it do: "a = #{a}"
      it do: "f.(2) = #{f.(2)}"
    end

    context "Use __" do
      before do: {:ok, x: 1}
      let :y, do: __[:x] + 1
      it do: "y = #{y}"
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
    assert(example.result == "a = 10")
  end

  test "run ex2", context do
    example = ESpec.ExampleRunner.run(context[:ex2])
    assert(example.result == "a = 20")
  end

  test "run ex3", context do
    example = ESpec.ExampleRunner.run(context[:ex3])
    assert(example.result == "f.(2) = 4")
  end

   test "run ex5", context do
    example = ESpec.ExampleRunner.run(context[:ex4])
    assert(example.result == "y = 2")
  end

end
