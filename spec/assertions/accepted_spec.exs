defmodule AcceptedSpec do
	use ESpec

	import ESpec.TestHelpers

	defmodule SomeModule do
		def f, do: :f
		def m, do: :m
	end |> write_beam

	describe "expect(module).to accepted(func, args)" do
		before do
			allow(SomeModule).to accept(:func, fn(a, b) -> a+b end)
			SomeModule.func(1, 2)
		end

		context "Success" do
			it do: expect SomeModule |> to(accepted(:func, [1, 2]))
			it do: expect SomeModule |> to_not(accepted(:another_function, []))
		end

		xcontext "Error" do
			it do: expect(SomeModule).to_not accepted(:func, [1, 2])
			it do: expect(SomeModule).to accepted(:another_function, [])
		end
	end

	describe "any args" do
		before do
			allow(SomeModule).to accept(:func, fn(a, b) -> a+b end)
			SomeModule.func(1, 2)
			SomeModule.func(1, 2)
		end

		it do: expect(SomeModule).to accepted(:func)
		it do: expect(SomeModule).to accepted(:func, :any)
		it do: expect(SomeModule).to_not accepted(:func, [2, 3])
	end

	describe "count option" do
		before do
			allow(SomeModule).to accept(:func, fn(a, b) -> a+b end)
			SomeModule.func(1, 2)
			SomeModule.func(1, 2)
		end

		it do: expect(SomeModule).to accepted(:func, [1, 2], count: 2)
		it do: expect(SomeModule).to_not accepted(:func, [1, 2], count: 1)
	end

	describe "pid option" do
		defmodule Server do
			def call(a, b) do
				SomeModule.func(a, b)
			end
		end

		before do
			allow(SomeModule).to accept(:func, fn(a, b) -> a+b end)
			pid = spawn(Server, :call, [10, 20])
			:timer.sleep(100)
			{:ok, pid: pid}
		end

		it "accepted with pid" do
			expect(SomeModule).to accepted(:func, [10, 20], pid: shared.pid)
		end

		it "not accepted with another pid" do
			expect(SomeModule).to_not accepted(:func, [10, 20], pid: self)
		end

		it "accepted with :any" do
			expect(SomeModule).to accepted(:func, [10, 20], pid: :any)
		end

		context "with count" do
			before do
				allow(SomeModule).to accept(:func, fn(a, b) -> a+b end)
				SomeModule.func(10, 20)
			end

			it do: expect(SomeModule).to accepted(:func, [10, 20], pid: :any, count: 2)
		end
	end
end
