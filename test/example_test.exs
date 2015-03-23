defmodule ExampleTest do

  use ExUnit.Case

  ESpec.start()
  defmodule SomeSpec do
    use ESpec

    example do: "some example"
    example "with name" do
      "example with name"
    end

    it do: "it example"
    it "is named eample" do
      "it is with name"
    end

  end

  setup_all do
    {:ok,
      ex1: Enum.at(SomeSpec.examples, 0),
      ex2: Enum.at(SomeSpec.examples, 1)
    }
  end

  test "check SomeSpec.examples length", context do
    assert(length(SomeSpec.examples) == 4)
  end

  test "check ex1", context do
    assert(context[:ex1].description == "")
    assert(context[:ex1].file ==  __ENV__.file)
    assert(context[:ex1].line == 9)
  end

  test "check ex2", context do
    assert(context[:ex2].description == "with name")
    assert(context[:ex2].file ==  __ENV__.file)
    assert(context[:ex2].line == 10)
  end

end
