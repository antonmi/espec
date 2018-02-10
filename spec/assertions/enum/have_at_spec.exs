defmodule ESpec.Assertions.Enum.HaveAtSpec do

  use ESpec, async: true

  let :range, do: (1..3)

  context "Success" do
    it "checks success with `to`" do
      message = expect(range()).to have_at(2, 3)
      expect(message) |> to(eq "`1..3` has element `3` at `2` position.")
    end

    it "checks success with `not_to`" do
      message = expect(range()).to_not have_at(2, 2)
      expect(message) |> to(eq "`1..3` doesn't have element `2` at `2` position.")
    end
  end

  context "Error" do
    context "with `to`" do
      before do
        {:shared,
          expectation: fn -> expect(range()).to have_at(2, 2) end,
          message: "Expected `1..3` to have `2` at `2` position, but it has `3`."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        {:shared,
          expectation: fn -> expect(range()).to_not have_at(2, 3) end,
          message: "Expected `1..3` not to have `3` at `2` position, but it has `3`."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end
  end

end
