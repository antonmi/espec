defmodule RunnerTest do

  use ExUnit.Case

  defmodule SomeSpec do
    use ESpec

    before do
      {:ok, a: 10}
    end
    it do: "a = #{__[:a]}"

    context "Context" do
      let :a, do: 20

      it do: "a = #{a}"
    end
  end

  setup_all do
    { :ok,
      ex1: Enum.at(SomeSpec.examples, 0),
      ex2: Enum.at(SomeSpec.examples, 1),
      ex3: Enum.at(SomeSpec.examples, 2)
    }
  end

  test "run_befores", context do
    map = ESpec.Runner.run_befores(%{}, context[:ex1], SomeSpec)
    assert(map[:a] == 10)
  end

  test "set_lets", context do
    ESpec.Runner.set_lets(%{}, context[:ex2], SomeSpec)
    {val, true, map} = ESpec.Let.agent_get({SomeSpec, :a})
    assert(val == 20)
  end

  test "run example", context do
    example = ESpec.Runner.run_example(context[:ex1], SomeSpec)
    assert(example.success == true)
  end

  test "run_examples", context do
    examples = ESpec.Runner.run_examples(SomeSpec.examples, SomeSpec)
    assert(List.first(examples).success == true)
    assert(List.first(examples).success == true)
  end

end
