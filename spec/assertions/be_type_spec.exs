defmodule ESpec.Assertions.BeTypeSpec do
	use ESpec, async: true

	context "Success" do
		it do: :atom |> should be_atom
		it do: "binary" |> should be_binary
		it do: <<102>> |> should be_bitstring
		it do: true |> should be_boolean
		it do: 1.2 |> should be_float
		it do: fn -> :ok end |> should be_function
		it do: 1 |> should be_integer
		it do: [1,2,3] |> should be_list
		it do: %{a: :b} |> should be_map
		it do: nil |> should be_nil
		it do: 1.5 |> should be_number
		it do: spawn(fn -> :ok end) |> should be_pid
		it do: hd(Port.list()) |> should be_port
		it do: make_ref |> should be_reference
		it do: {:a, :b} |> should be_tuple
		it do: fn(_a, _b) -> :ok end |> should be_function(2)
	end

	xcontext "Error" do
		it do: 1 |> should be_atom
		it do: :atom |> should_not be_atom

		it do: 5 |> should be_nil
		it do: nil |> should_not be_nil

		it do: fn(_a) -> :ok end |> should be_function(2)
		it do: fn(_a, _b) -> :ok end |> should_not be_function(2)
	end
end
