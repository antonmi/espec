defmodule AcceptedSpec do

	use ESpec
	
	describe "expect(module).to accepted(func, args)" do
		before do
			allow(ESpec.SomeModule).to accept(:func, fn(a, b) -> a+b end)
			ESpec.SomeModule.func(1, 2)
		end

		context "Success" do
			it do: expect(ESpec.SomeModule).to accepted(:func, [1, 2])
		 	it do: expect(ESpec.SomeModule).to_not accepted(:another_function, [])
		end

		xcontext "Error" do
			it do: expect(ESpec.SomeModule).to_not accepted(:func, [1, 2])
			it do: expect(ESpec.SomeModule).to accepted(:another_function, [])
		end
	end

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
