defmodule ConfigBeforeTest do
  use ExUnit.Case, async: true

  ESpec.configure fn(c) ->
    c.before fn ->
      {:shared, answer: 42}
    end
  end

  test "set before in config" do
    assert(ESpec.Configuration.get(:before).() == {:shared, answer: 42})
  end
  
  defmodule SomeSpec do
    use ESpec

    it do: "answer is #{shared[:answer]}"

    context "with before and let" do
      before do: {:ok, answer: shared[:answer] + 1}
      let :answer, do: shared[:answer] + 1
      it do: "answer is #{answer}"
    end
  end

  setup_all do
    {:ok,
      ex1: Enum.at(SomeSpec.examples, 0),
      ex2: Enum.at(SomeSpec.examples, 1)
    }
  end

  test "run ex1", context do
    example = ESpec.ExampleRunner.run(context[:ex1])
    assert(example.result == "answer is 42")
  end

  test "run ex2", context do
    example = ESpec.ExampleRunner.run(context[:ex2])
    assert(example.result == "answer is 44")
  end
end
