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

  test "run example", context do
    example = ESpec.Runner.run_example(context[:ex1])
    assert(example.status == :success)
  end

  test "run_examples" do
    examples = ESpec.Runner.run_examples(SomeSpec.examples)
    assert(List.first(examples).status == :success)
    assert(List.first(examples).status == :success)
  end

end
