defmodule ESpec.Assertions.List.HaveFirstSpec do
  use ESpec, async: true

  subject [1,2,3]

  context "Success" do
    it "checks success with `to`" do
      message = should have_first 1
      expect(message) |> to(eq "`[1, 2, 3]` has first element `1`.")
    end

    it "checks success with `not_to`" do
      message = should_not have_first 2
      expect(message) |> to(eq "`[1, 2, 3]` doesn't have first element `2`.")
    end
  end

  context "Error" do
    context "with `to`" do
      before do
        { :shared,
          expectation: fn -> should have_first 2 end,
          message: "Expected `[1, 2, 3]` to have first element `2` but it has `1`."
        }
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        { :shared,
          expectation: fn -> should_not have_first 1 end,
          message: "Expected `[1, 2, 3]` not to have first element `1` but it has `1`."
        }
      end

      it_behaves_like(CheckErrorSharedSpec)
    end
  end
end
