defmodule ConfigFinallyTest2 do
  use ExUnit.Case

  defmodule SomeSpec do
    use ESpec

    before do: {:ok, a: 1}
    finally do: {:ok, a: shared[:a] + 1}
    it do: "some test"
  end

  setup_all do
    ESpec.configure(fn c ->
      c.finally(fn assigns ->
        ESpec.configure(fn c -> c.test(assigns[:a]) end)
      end)
    end)

    {:ok, ex1: Enum.at(SomeSpec.examples(), 0)}
  end

  test "run ex1", context do
    ESpec.ExampleRunner.run(context[:ex1])
    assert(ESpec.Configuration.get(:test) == 2)
  end
end
