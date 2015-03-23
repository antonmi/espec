defmodule ContextTest do

  use ExUnit.Case

  ESpec.start()
  defmodule SomeSpec do
    use ESpec

    it do: "is in Top context"

    context "Context 1" do
      it do: "is in Context 1"

      describe "Describe 1" do
        it do: "is in Describe 1"
      end
    end
  end

  setup_all do
    {:ok,
      ex1: Enum.at(SomeSpec.examples, 0),
      ex2: Enum.at(SomeSpec.examples, 1),
      ex3: Enum.at(SomeSpec.examples, 2)
    }
  end

  test "check ex1", context do
    assert(length(context[:ex1].context) == 0)
  end

  test "check ex2", context do
    desc = Enum.map(context[:ex2].context, &(&1.description))
    assert(desc == ["Context 1"])
  end

  test "check ex3", context do
    desc = Enum.map(context[:ex3].context, &(&1.description))
    assert(desc == ["Context 1", "Describe 1"])
  end

end
