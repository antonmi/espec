defmodule AllowSpec do

	use ESpec

	defmodule SomeModule do
		def func(a), do: IO.puts "func is called with #{a}"
	end

	before do
		allow(SomeModule).to receive(:func, fn(a) -> "mock! #{a}" end)
	end

	it do
		expect(SomeModule.func(1)).to eq("mock! 1")
	end
end
