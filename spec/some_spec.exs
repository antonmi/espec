defmodule SomeSpec do
	use ESpec

	context ESpec do
		it do: 1 |> should eq 1
	end

	describe ESpec.Context do
		it  do: 1 |> should eq 1
	end
end 

