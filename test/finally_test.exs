defmodule FinallyTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    before do: {:ok, a: 1}
    finally do
      Application.put_env(:espec, :finally_a, 1)
      {:ok, b: __[:a] + 1}
    end 

    finally do: Application.put_env(:espec, :finally_b, __[:b])


    it do: "some test"
    finally do: Application.put_env(:espec, :finally_c, 3)
  end

  setup_all do
    {:ok,
      ex1: Enum.at(SomeSpec.examples, 0)
    }
  end

  test "run ex1", context do
    ESpec.ExampleRunner.run(context[:ex1])
    assert(Application.get_env(:espec, :finally_a) == 1)
    assert(Application.get_env(:espec, :finally_b) == 2)
    assert(Application.get_env(:espec, :finally_c) == nil)
  end
end
