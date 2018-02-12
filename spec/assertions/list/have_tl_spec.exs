defmodule ESpec.Assertions.List.HaveTlSpec do
  use ESpec, async: true

  subject [1, 2, 3]

  context "Success" do
    it "checks success with `to`" do
      message = should(have_tl([2, 3]))
      expect(message) |> to(eq "`[1, 2, 3]` has `tl` == `[2, 3]`.")
    end

    it "checks success with `not_to`" do
      message = should_not(have_tl([1, 2]))
      expect(message) |> to(eq "`[1, 2, 3]` doesn't have `tl` == `[1, 2]`.")
    end
  end

  context "Error" do
    context "with `to`" do
      before do
        {:shared,
         expectation: fn -> should(have_tl([1, 2])) end,
         message: "Expected `[1, 2, 3]` to have `tl` `[1, 2]` but it has `[2, 3]`."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        {:shared,
         expectation: fn -> should_not(have_tl([2, 3])) end,
         message: "Expected `[1, 2, 3]` not to have `tl` `[2, 3]` but it has `[2, 3]`."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end
  end
end
