defmodule ESpec.Assertions.String.Have do
  use ESpec, async: true

  subject "qwerty"

  context "Success" do
    it "checks success with `to`" do
      message = should have("we")
      expect(message) |> to(eq "`\"qwerty\"` has `\"we\"`.")
    end

    it "checks success with `not_to`" do
      message = should_not have("z")
      expect(message) |> to(eq "`\"qwerty\"` doesn't have `\"z\"`.")
    end
  end

  context "Error" do
    context "with `to`" do
      before do
        { :shared,
          expectation: fn -> should have("zx") end,
          message: "Expected `\"qwerty\"` to have `\"zx\"`, but it has not."
        }
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        { :shared,
          expectation: fn -> should_not have("qwe") end,
          message: "Expected `\"qwerty\"` not to have `\"qwe\"`, but it has."
        }
      end

      it_behaves_like(CheckErrorSharedSpec)
    end
  end
end
