defmodule AcceptedTest do

	use ExUnit.Case

	defmodule SomeSpec do
		use ESpec

		describe "function call in another process" do
			defmodule Server do
				def call(a, b) do
					ESpec.SomeModule.func(a, b)
				end
			end

			before do
				allow(ESpec.SomeModule).to accept(:func, fn(a, b) -> a+b end)
				pid = spawn(Server, :call, [10, 20])
				:timer.sleep(100)
				{:ok, pid: pid}
			end

			it "accepted with pid" do
				expect(ESpec.SomeModule).to accepted(:func, [10, 20], __.pid)
			end

			it "not accepted with another pid" do
				expect(ESpec.SomeModule).to_not accepted(:func, [10, 20], self)
			end

			it "accepted with :any" do
				expect(ESpec.SomeModule).to accepted(:func, [10, 20], :any)
			end
		end
	end

	setup_all do
    {:ok,
      ex1: Enum.at(SomeSpec.examples, 0),
      ex2: Enum.at(SomeSpec.examples, 1),
      ex3: Enum.at(SomeSpec.examples, 2),
    }
  end


	test "run ex1", context do
    example = ESpec.Runner.run_example(context[:ex1])
    assert(example.status == :success)
  end 

  test "run ex2", context do
    example = ESpec.Runner.run_example(context[:ex2])
    assert(example.status == :success)
  end 

  test "run ex3", context do
    example = ESpec.Runner.run_example(context[:ex3])
    assert(example.status == :success)
  end 




end