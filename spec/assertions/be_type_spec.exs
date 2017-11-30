defmodule ESpec.Assertions.BeTypeSpec do
  use ESpec, async: true

  context "Success" do
    it "checks success with `to`" do
      message = :atom |> should(be_atom())
      expect(message) |> to(eq "`:atom` is is `atom`.")
    end

    it "checks success with `not_to`" do
      message = 123 |> should_not(be_atom())
      expect(message) |> to(eq "`123` is not is `atom`.")
    end

    it do: "binary" |> should(be_binary())
    it do: <<102>> |> should(be_bitstring())
    it do: true |> should(be_boolean())
    it do: 1.2 |> should(be_float())
    it do: fn -> :ok end |> should(be_function())
    it do: 1 |> should(be_integer())
    it do: [1, 2, 3] |> should(be_list())
    it do: %{a: :b} |> should(be_map())
    it do: nil |> should(be_nil())
    it do: 1.5 |> should(be_number())
    it do: spawn(fn -> :ok end) |> should(be_pid())
    it do: hd(Port.list()) |> should(be_port())
    it do: make_ref() |> should(be_reference())
    it do: {:a, :b} |> should(be_tuple())
    it do: fn(_a, _b) -> :ok end |> should(be_function(2))
    it do: %{__struct__: S} |> should(be_struct())
    it do: %{__struct__: S} |> should(be_struct(S))
  end

  context "Error" do
    context "with `to`" do
      before do
        {:shared,
          expectation: fn -> 1 |> should(be_atom()) end,
          message: "Expected `1` to be `atom` but it isn't."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        {:shared,
          expectation: fn -> :atom |> should_not(be_atom()) end,
          message: "Expected `:atom` not to be `atom` but it is."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end
  end
end
