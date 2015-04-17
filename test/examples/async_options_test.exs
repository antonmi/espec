defmodule AsyncOptionTest do

  use ExUnit.Case

  defmodule SomeSpecAsync do
    use ESpec, async: true

    it do: "async example 1"
    it do: "async example 2"
  end

  defmodule SomeSpecSync do
    use ESpec

    it do: "async example 1"
    it do: "async example 2"
  end

  setup_all do
    {:ok,
      ex1: Enum.at(SomeSpecAsync.examples, 0),
      ex2: Enum.at(SomeSpecAsync.examples, 1),
      ex3: Enum.at(SomeSpecSync.examples, 0),
      ex4: Enum.at(SomeSpecSync.examples, 1)
    }
  end

  test "check example", context do
    assert context[:ex1].async == true
    assert context[:ex2].async == true
    assert context[:ex3].async == false
    assert context[:ex4].async == false
  end
end