defmodule ESpec.Assertions.List.HaveLastSpec do
  use ESpec, async: true

  subject [1, 2, 3]

  context "Success" do
    it "checks success with `to`" do
      message = should have_last 3
      expect(message) |> to(eq "`[1, 2, 3]` has last element `3`.")
    end

    it "checks success with `not_to`" do
      message = should_not have_last 2
      expect(message) |> to(eq "`[1, 2, 3]` doesn't have last element `2`.")
    end
  end

  context "Error" do
    context "with `to`" do
      before do
        {:shared,
          expectation: fn -> should have_last 2 end,
          message: "Expected `[1, 2, 3]` to have last element `2` but it has `3`."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        {:shared,
          expectation: fn -> should_not have_last 3 end,
          message: "Expected `[1, 2, 3]` not to have last element `3` but it has `3`."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end
  end
end
