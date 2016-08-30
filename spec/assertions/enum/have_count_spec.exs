defmodule ESpec.Assertions.Enum.HaveCountSpec do
  use ESpec, async: true

  let :range, do: (1..3)

  context "Success" do
    it "checks success with `to`" do
      message = expect(range).to have_count(3)
      expect(message) |> to(eq "`1..3` has `3` elements.")
    end

    it "checks success with `not_to`" do
      message = expect(range).to_not have_count(2)
      expect(message) |> to(eq "`1..3` doesn't have `2` elements.")
    end
  end

  context "aliases" do
    it do: expect(range).to have_size(3)
    it do: expect(range).to have_length(3)
  end

  context "Error" do
    context "with `to`" do
      before do
        {:shared,
          expectation: fn -> expect(range).to have_count(2) end,
          message: "Expected `1..3` to have `2` elements but it has `3`."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        {:shared,
          expectation: fn -> expect(range).to_not have_count(3) end,
          message: "Expected `1..3` not to have `3` elements but it has `3`."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end
  end
end
