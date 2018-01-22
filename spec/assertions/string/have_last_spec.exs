defmodule ESpec.Assertions.String.HaveLastSpec do
  use ESpec, async: true

  subject "qwerty"

  context "Success" do
    it "checks success with `to`" do
      message = should(have_last "y")
      expect(message) |> to(eq "`\"qwerty\"` has last element `\"y\"`.")
    end

    it "checks success with `not_to`" do
      message = should_not(have_last "r")
      expect(message) |> to(eq "`\"qwerty\"` doesn't have last element `\"r\"`.")
    end
  end

  context "Error" do
    context "with `to`" do
      before do
        {:shared,
         expectation: fn -> should(have_last "w") end,
         message: "Expected `\"qwerty\"` to have last element `\"w\"` but it has `y`."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        {:shared,
         expectation: fn -> should_not(have_last "y") end,
         message: "Expected `\"qwerty\"` not to have last element `\"y\"` but it has `y`."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end
  end
end
