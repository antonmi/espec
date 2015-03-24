defmodule ExampleTest do

  use ExUnit.Case

  defmodule SomeSpec do
    use ESpec

    example do: "some example"
    example "failed example with name" do
      expect(true).to be(false)
    end

    it do: "it example"
    it "is named example" do
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
    assert(context[:ex1].line == 8)
  end

  test "run ex1", context do
    example = ESpec.Runner.run_example(context[:ex1], SomeSpec)
    assert(example.success == true)
    assert(example.result == "some example")
  end

  test "check ex2", context do
    assert(context[:ex2].description == "failed example with name")
    assert(context[:ex2].file ==  __ENV__.file)
    assert(context[:ex2].line == 9)
  end

  test "run ex2", context do
    example = ESpec.Runner.run_example(context[:ex2], SomeSpec)
    assert(example.success == false)
    assert(example.error.act == true)
    assert(example.error.exp == false)
  end

end
