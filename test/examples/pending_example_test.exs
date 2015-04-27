defmodule PendingExampleTest do

  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    it do: "Example"
    it "peding", [pending: true], do: "pending"
    it "pending with message", [pending: "some message"], do: "pending"

    it "pending with message"
    example "pending with message"
    specify "pending with message"
    pending "pending with message"
  end

  setup_all do
    examples = ESpec.Runner.run_examples(SomeSpec.examples)
    {:ok,
      ex1: Enum.at(examples, 0),
      ex2: Enum.at(examples, 1),
      ex3: Enum.at(examples, 2),
      ex4: Enum.at(examples, 3),
      ex5: Enum.at(examples, 4),
      ex6: Enum.at(examples, 5),
      ex7: Enum.at(examples, 6)
    }
  end

  test "ex2", context do    
    assert(context[:ex2].status == :pending)
    assert(context[:ex2].result == "Pending example.")
  end

  test "ex3", context do    
    assert(context[:ex3].status == :pending)
    assert(context[:ex3].result == "Pending with message: some message.")
  end

  test "ex4", context do    
    assert(context[:ex4].status == :pending)
    assert(context[:ex4].result == "Pending with message: pending with message.")
  end

  test "ex5", context do    
    assert(context[:ex5].status == :pending)
    assert(context[:ex5].result == "Pending with message: pending with message.")
  end

  test "ex6", context do    
    assert(context[:ex6].status == :pending)
    assert(context[:ex6].result == "Pending with message: pending with message.")
  end

  test "ex7", context do    
    assert(context[:ex7].status == :pending)
    assert(context[:ex7].result == "Pending with message: pending with message.")
  end
end