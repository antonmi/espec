defmodule ConfigFinallyTest do

	use ExUnit.Case, async: true
	
	defmodule SomeSpec do
    use ESpec
    it do: "some test"
  end

	setup_all do
    ESpec.configure fn(c) ->
      c.finally fn -> 
        ESpec.configure fn(c) -> c.test :ok end
      end
    end
    {:ok,
      ex1: Enum.at(SomeSpec.examples, 0),
    }
  end

  test "run ex1", context do
  	ESpec.ExampleRunner.run(context[:ex1])
    assert(ESpec.Configuration.get(:test) == :ok)
  end
end
