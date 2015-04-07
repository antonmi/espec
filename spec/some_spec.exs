defmodule SomeSpec do
	use ESpec

	let :a, do: 1
	subject! do: SomeSpec.a + 1

	it do: should eq 2
end 

