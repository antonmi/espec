defmodule SomeSpec do

	use ESpec

	it "skip", skip: true do
		IO.puts "skipped"
	end

end
