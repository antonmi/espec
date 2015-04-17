defmodule FinallySpec do

	use ESpec, async: true

	before do: {:ok, a: 1}

	finally do: "a = #{__[:a]}"

	it do: expect(__[:a]).to eq(1)

end