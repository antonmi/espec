defmodule ModuleAsTopContextTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec, a: 1, b: 2
    it do: "example"
  end  

  setup_all do
    {:ok,
      ex1: Enum.at(SomeSpec.examples, 0), 
    }
  end

  test "check ex1 context", context do
    cont = hd(context[:ex1].context)

    assert(cont.description == "ModuleAsTopContextTest.SomeSpec")
    assert(cont.module == ModuleAsTopContextTest.SomeSpec)
    assert(cont.line == 5)
    assert(cont.opts == [a: 1, b: 2])
  end

  test "ex1 full description", context do
    assert ESpec.Example.context_descriptions(context[:ex1]) == ["ModuleAsTopContextTest.SomeSpec"]
  end
end
