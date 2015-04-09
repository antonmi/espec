defmodule SomeSpec do
	use ESpec

	before do
		{:ok, [%{data: "some_data", id: 100500}]}
	end

	it do: ""
end 

