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
  end

  setup_all do
    {:ok,
      ex1: Enum.at(SomeSpec.examples, 0),
      ex2: Enum.at(SomeSpec.examples, 1),
      ex3: Enum.at(SomeSpec.examples, 2)
    }
  end

  test "check let value in ex1", context do
    ESpec.Runner.set_lets(context[:ex1], SomeSpec)
    val = ESpec.Let.let_agent_get({SomeSpec, :a})
    assert(val == 10)
  end

  test "run ex1", context do
    example = ESpec.Runner.run_example(context[:ex1], SomeSpec)
    assert(example.result == "a = 10")
  end

  test "run ex2", context do
    example = ESpec.Runner.run_example(context[:ex2], SomeSpec)
    assert(example.result == "a = 20")
  end

  test "run ex3", context do
    example = ESpec.Runner.run_example(context[:ex3], SomeSpec)
    assert(example.result == "f.(2) = 4")
  end

end
