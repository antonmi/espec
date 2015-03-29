defmodule AcceptedSpec do

	use ESpec
	
	describe "expect(module).to accepted(func, args)" do
		before do
			allow(ESpec.SomeModule).to accept(:func, fn(a, b) -> a+b end)
		end

		before do
			ESpec.SomeModule.func(1, 2)
		end

		it do: expect(ESpec.SomeModule).to accepted(:func, [1, 2])
		it do: expect(ESpec.SomeModule).to_not accepted(:another_function, [])
	end

end
