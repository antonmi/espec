defmodule ConfigBeforeTest do

	use ExUnit.Case

	ESpec.configure fn(c) ->
		c.before fn ->
			{:ok, answer: 42}
		end
	end

	test "set before in config" do
		assert(ESpec.Configuration.get(:before).() == {:ok, answer: 42})
	end
	
	defmodule SomeSpec do
    use ESpec

    it do: "answer is #{__[:answer]}"

    context "with before and let" do
    	before do: {:ok, answer: __[:answer] + 1}
    	let :answer, do: __[:answer] + 1
			it do: "answer is #{answer}"
    end
  end

	setup_all do
    {:ok,
      ex1: Enum.at(SomeSpec.examples, 0),
      ex2: Enum.at(SomeSpec.examples, 1)
    }
  end

  test "run ex1", context do
  	example = ESpec.Runner.run_example(context[:ex1], SomeSpec)
    assert(example.result == "answer is 42")
  end

  test "run ex2", context do
  	example = ESpec.Runner.run_example(context[:ex2], SomeSpec)
    assert(example.result == "answer is 44")
  end

end