defmodule ESpec.Assertions.Enum.BeEmptySpec do
  use ESpec, async: true

  context "Success" do
    it "checks success with `to`" do
      message = expect([]).to be_empty
      expect(message) |> to(eq "`[]` is empty.")
    end

    it "checks success with `not_to`" do
      message = expect([1,2,3]).to_not be_empty
      expect(message) |> to(eq "`[1, 2, 3]` is not empty.")
    end
  end

  context "Error" do
    context "with `to`" do
      before do
        { :shared,
          expectation: fn -> expect([1,2,3]).to be_empty end,
          message: "Expected `[1, 2, 3]` to be empty, but it has `3` elements."
        }
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        { :shared,
          expectation: fn -> expect([]).to_not be_empty end,
          message: "Expected `[]` not to be empty, but it is."
        }
      end

      it_behaves_like(CheckErrorSharedSpec)
    end
  end
end
