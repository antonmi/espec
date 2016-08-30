defmodule ESpec.Assertions.String.HaveFirstSpec do
  use ESpec, async: true

  subject "qwerty"

  context "Success" do
    it "checks success with `to`" do
      message = should have_first "q"
      expect(message) |> to(eq "`\"qwerty\"` has first element `\"q\"`.")
    end

    it "checks success with `not_to`" do
      message = should_not have_first "w"
      expect(message) |> to(eq "`\"qwerty\"` doesn't have first element `\"w\"`.")
    end
  end

  context "Error" do
    context "with `to`" do
      before do
        {:shared,
          expectation: fn -> should have_first "w" end,
          message: "Expected `\"qwerty\"` to have first element `\"w\"` but it has `q`."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        {:shared,
          expectation: fn -> should_not have_first "q" end,
          message: "Expected `\"qwerty\"` not to have first element `\"q\"` but it has `q`."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end
  end
end
