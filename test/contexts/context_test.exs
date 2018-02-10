defmodule ContextTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    it do: "is in Top context"

    context "Context 1", a: 1, b: 2 do
      it do: "is in Context 1"

      ESpec.Context.describe "Describe 1" do
        it do: "is in Describe 1"
      end
    end

    context do
      it do: "in context without description"
    end

    context c: 3 do
      it do: "in context without description bu with opts"
    end

    ESpec.Context.describe "is alias" do
      it do: "some example"
    end

    example_group "is alias" do
      it do: "some example"
    end

    context ESpec.Context do
      it do: "context with atom as description"
    end

    context "Do nothing with empty context"
    ESpec.Context.describe "Do nothing with empty context"
    example_group "Do nothing with empty context"
  end

  setup_all do
    {:ok,
      ex1: Enum.at(SomeSpec.examples, 0),
      ex2: Enum.at(SomeSpec.examples, 1),
      ex3: Enum.at(SomeSpec.examples, 2),
      ex4: Enum.at(SomeSpec.examples, 3),
      ex5: Enum.at(SomeSpec.examples, 4),
      ex8: Enum.at(SomeSpec.examples, 7)
    }
  end

  test "check ex1", context do
    assert(length(context[:ex1].context) == 1)
    desc = hd(context[:ex1].context).description
    assert(desc == "ContextTest.SomeSpec")
  end

  test "check ex2", context do
    desc = Enum.map(context[:ex2].context, &(&1.description))
    assert(desc == ["ContextTest.SomeSpec", "Context 1"])
  end

  test "check ex2 context options", context do
    opts = List.last(context[:ex2].context).opts
    assert(opts == [a: 1, b: 2])
  end

  test "check ex3", context do
    desc = Enum.map(context[:ex3].context, &(&1.description))
    assert(desc == ["ContextTest.SomeSpec", "Context 1", "Describe 1"])
  end

  test "check ex4 context", context do
    desc = List.last(context[:ex4].context).description
    assert(desc == "")
  end

  test "check ex5 context", context do
    desc = List.last(context[:ex5].context).description
    opts = List.last(context[:ex5].context).opts
    assert(desc == "")
    assert(opts == [c: 3])
  end

  test "check ex6 context", context do
    desc = List.last(context[:ex8].context).description
    assert(desc == ESpec.Context)
  end
end
