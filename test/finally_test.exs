defmodule FinallyTest do

  use ExUnit.Case

  defmodule SomeSpec do
    use ESpec

    before do: {:ok, a: 1}
    finally do: "a = #{__[:a]}"
    finally do: "another finally"

    it do: "#{__[:a]} is defined"

    finally do: "it will not be evaluated"
  end

  setup_all do
    {:ok,
      ex1: Enum.at(SomeSpec.examples, 0)
    }
  end

  test "finallies", context do
    assigns = ESpec.Runner.run_befores(context[:ex1], SomeSpec)
    result = ESpec.Runner.run_finallies(context[:ex1], SomeSpec, assigns)
    assert(result == ["a = 1", "another finally"])
  end

end
