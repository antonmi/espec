defmodule SomeSpec do
	use ESpec

	let :a, do: 1
	let :b, do: SomeSpec.a + 1

	it do: b |> should eq 2
end 

