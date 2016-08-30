defmodule ESpec.Assertions.String.EndWithSpec do
  use ESpec, async: true

  subject "qwerty"

  context "Success" do
    it "checks success with `to`" do
      message = should end_with "rty"
      expect(message) |> to(eq "`\"qwerty\"` ends with `\"rty\"`.")
    end

    it "checks success with `not_to`" do
      message = should_not end_with "ert"
      expect(message) |> to(eq "`\"qwerty\"` doesn't end with `\"ert\"`.")
    end
  end

  context "Error" do
    context "with `to`" do
      before do
        {:shared,
          expectation: fn -> should end_with "ert" end,
          message: "Expected `\"qwerty\"` to end with `ert` but it ends with `...rty`."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        {:shared,
          expectation: fn -> should_not end_with "rty" end,
          message: "Expected `\"qwerty\"` not to end with `rty` but it ends with `rty`."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end
  end

  context "Short string" do
    subject "q"

    context "Success" do
      it "checks success with `to`" do
        message = should end_with "q"
        expect(message) |> to(eq "`\"q\"` ends with `\"q\"`.")
      end

      it "checks success with `not_to`" do
        message = should_not end_with "ert"
        expect(message) |> to(eq "`\"q\"` doesn't end with `\"ert\"`.")
      end
    end

    context "Error" do
      context "with `to`" do
        before do
          {:shared,
            expectation: fn -> should end_with "e" end,
            message: "Expected `\"q\"` to end with `e` but it ends with `...q`."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          {:shared,
            expectation: fn -> should_not end_with "q" end,
            message: "Expected `\"q\"` not to end with `q` but it ends with `q`."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end
  end
end
