defmodule ExampleTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    example do: "some example"
    example "failed example with name" do
      :timer.sleep(2)
      expect(true).to be(false)
    end

    it [a: 1, b: 2], do: "it example with opts"
    it "is named example with opts", c: 3 do
      "it is with name"
    end

    example "example with unicode letters áéíóúàèìòùäëïöü" do
    end

    specify do: "another example"
    specify "name", do: "another example"
    specify "name", [], do: "another example"
  end

  setup_all do
    {:ok,
      ex1: Enum.at(SomeSpec.examples, 0),
      ex2: Enum.at(SomeSpec.examples, 1),
      ex3: Enum.at(SomeSpec.examples, 2),
      ex4: Enum.at(SomeSpec.examples, 3),
      unicode: Enum.at(SomeSpec.examples, 4)
    }
  end

  test "check SomeSpec.examples length" do
    assert(length(SomeSpec.examples) == 8)
  end

  test "check ex1", context do
    assert(context[:ex1].description == "")
    assert(context[:ex1].file ==  __ENV__.file)
    assert(context[:ex1].line == 7)
  end

  test "run ex1", context do
    example = ESpec.ExampleRunner.run(context[:ex1])
    assert(example.status == :success)
    assert(example.result == "some example")
  end

  test "check ex2", context do
    assert(context[:ex2].description == "failed example with name")
    assert(context[:ex2].file ==  __ENV__.file)
    assert(context[:ex2].line == 8)
  end

  test "run ex2", context do
    example = ESpec.ExampleRunner.run(context[:ex2])
    assert(example.status == :failure)
    assert(example.error.subject == true)
    assert(example.error.data == false)
    assert(example.error.result != nil)
    assert(example.error.asserion == ESpec.Assertions.Eq)
    assert(example.duration > 0)
  end

  test "ex3 opts", context do
    assert(context[:ex3].opts == [a: 1, b: 2])
  end

  test "ex4 opts", context do
    assert(context[:ex4].opts == [c: 3])
  end

  test "check unicode example", context do
    assert(context[:unicode].description == "example with unicode letters áéíóúàèìòùäëïöü")
  end
end
