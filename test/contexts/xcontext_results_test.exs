defmodule XcontextResultsTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    it [skip: true], do: "Example"
    it [skip: "Some message"], do: "Example"
    xit do: "Example"

    context "Skip", skip: true do
      it [skip: "Some message"], do: "Example"
    end

    xcontext "Skip", [some: :option] do
      it do: "Example"
    end
  end

  setup_all do
    examples = ESpec.Runner.run_examples(SomeSpec.examples)
    {:ok,
      ex1: Enum.at(examples, 0),
      ex2: Enum.at(examples, 1),
      ex3: Enum.at(examples, 2),
      ex4: Enum.at(examples, 3),
      ex5: Enum.at(examples, 4)
    }
  end

  test "check ex1", context do
    assert(context[:ex1].result == "Temporarily skipped without a reason.")
  end

  test "check ex2", context do
    assert(context[:ex2].result == "Temporarily skipped with: Some message.")
  end

  test "check ex3", context do
    assert(context[:ex3].result == "Temporarily skipped with: `xit`.")
  end

  test "check ex4", context do
    assert(context[:ex4].result == "Temporarily skipped with: Some message.")
  end

  test "check ex5", context do
    assert(context[:ex5].result == "Temporarily skipped with: `xcontext`.")
  end
end
