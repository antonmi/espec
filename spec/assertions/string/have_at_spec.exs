defmodule ESpec.Assertions.String.HaveAt do
  use ESpec, async: true

  subject "qwerty"

  context "Success" do
    it "checks success with `to`" do
      message = should have_at(2, "e")
      expect(message) |> to(eq "`\"qwerty\"` has element `e` at `2` position.")
    end

    it "checks success with `not_to`" do
      message = should_not have_at(2, "q")
      expect(message) |> to(eq "`\"qwerty\"` doesn't have element `q` at `2` position.")
    end
  end

  context "Error" do
    context "with `to`" do
      before do
        { :shared,
          expectation: fn -> should have_at(2, "q") end,
          message: "Expected `\"qwerty\"` to have `\"q\"` at `2` position, but it has `e`."
        }
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        { :shared,
          expectation: fn -> should_not have_at(2, "e") end,
          message: "Expected `\"qwerty\"` not to have `\"e\"` at `2` position, but it has `e`."
        }
      end

      it_behaves_like(CheckErrorSharedSpec)
    end
  end
end
