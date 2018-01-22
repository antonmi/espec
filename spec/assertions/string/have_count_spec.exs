defmodule ESpec.Assertions.String.HaveCountSpec do
  use ESpec, async: true

  subject "qwerty"

  context "Success" do
    it "checks success with `to`" do
      message = should(have_count(6))
      expect(message) |> to(eq "`\"qwerty\"` has `6` elements.")
    end

    it "checks success with `not_to`" do
      message = should_not(have_count(3))
      expect(message) |> to(eq "`\"qwerty\"` doesn't have `3` elements.")
    end
  end

  context "aliases" do
    it "checks success with `to`" do
      message = should(have_size(6))
      expect(message) |> to(eq "`\"qwerty\"` has `6` elements.")
    end

    it "checks success with `not_to`" do
      message = should(have_length(6))
      expect(message) |> to(eq "`\"qwerty\"` has `6` elements.")
    end
  end

  context "Error" do
    context "with `to`" do
      before do
        {:shared,
         expectation: fn -> should(have_count(3)) end,
         message: "Expected `\"qwerty\"` to have `3` elements but it has `6`."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        {:shared,
         expectation: fn -> should_not(have_count(6)) end,
         message: "Expected `\"qwerty\"` not to have `6` elements but it has `6`."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end
  end
end
