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
				expect(ESpec.SomeModule).to accepted(:func, [10, 20], pid: __.pid)
			end

			it "not accepted with another pid" do
				expect(ESpec.SomeModule).to_not accepted(:func, [10, 20], pid: self)
			end

			it "accepted with :any" do
				expect(ESpec.SomeModule).to accepted(:func, [10, 20], pid: :any)
			end
		end

		describe "count option" do
			before do
				allow(ESpec.SomeModule).to accept(:func, fn(a, b) -> a+b end)
				ESpec.SomeModule.func(1, 2)
				ESpec.SomeModule.func(1, 2)
			end

			it do: expect(ESpec.SomeModule).to accepted(:func, [1, 2], count: 2)
			it do: expect(ESpec.SomeModule).to_not accepted(:func, [1, 2], count: 1)
		end

		describe "any args" do
			before do
				allow(ESpec.SomeModule).to accept(:func, fn(a, b) -> a+b end)
				ESpec.SomeModule.func(1, 2)
			end

			it do: expect(ESpec.SomeModule).to accepted(:func)
			it do: expect(ESpec.SomeModule).to accepted(:func, :any)
		end	
	end

	setup_all do
    examples = ESpec.Runner.run_examples(SomeSpec.examples)
    { :ok,
      success: Enum.slice(examples, 0, 6)
    }
  end

  test "Success", context do
    Enum.each(context[:success], fn(ex) ->
      assert(ex.status == :success)
    end)
  end

end