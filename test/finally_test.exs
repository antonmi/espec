defmodule FinallyTest do

  use ExUnit.Case

  defmodule SomeSpec do
    use ESpec

    before do: {:ok, a: 1}

    finally do: "do smth"
    finally do: {:ok, b: __[:a] + 1}

    it do: "some test"

    finally do: "it will not be evaluated"
  end

  setup_all do
    {:ok,
      ex1: Enum.at(SomeSpec.examples, 0)
    }
  end

  test "finallies", context do
    assigns = ESpec.Runner.run_befores(%{}, context[:ex1], SomeSpec)
    result = ESpec.Runner.run_finallies(assigns, context[:ex1], SomeSpec)
    assert(result[:a] == 1)
    assert(result[:b] == 2)
  end

end
