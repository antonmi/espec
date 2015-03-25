defmodule AllowSpec do

	use ESpec

	defmodule SomeModule do
		def func(a), do: IO.puts "func is called with #{a}"
		def func2(a), do: IO.puts "antoher function 'func2' is called with #{a}"
	end

	describe "allow(module).to receive(name, func)" do

		before do
			allow(SomeModule).to receive(:func, fn(a) -> "mock! #{a}" end)
		end

		it do: expect(SomeModule.func(1)).to eq("mock! 1")
	end

	describe "allow(module).to receive_messages(name1: func1, name2: func2)" do
		before do
			allow(SomeModule).to receive_messages(
				func: fn(a) -> "mock! #{a}" end,
				func2: fn -> "mock! func2" end
			)
		end

		it do: expect(SomeModule.func(1)).to eq("mock! 1")
		it do: expect(SomeModule.func2).to eq("mock! func2")
	end

end
