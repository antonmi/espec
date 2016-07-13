defmodule ESpec.Assertions.Boolean.BeFalseSpec do
  require CheckErrorSharedSpec
  use ESpec, async: true

  context "Success" do
    it "checks success with `to`" do
      message = expect(false).to be_false
      expect(message) |> to(eq "`false` is false.")
    end

    it "checks success with `not_to`" do
      message = expect(1).to_not be_false
      expect(message) |> to(eq "`1` is not false.")
    end
  end

  context "Errors" do
    context "with `to`" do
      before do
        { :shared,
          expectation: fn -> expect(true).to be_false end,
          message: "Expected `true` to be false but it isn't."
        }
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        { :shared,
          expectation: fn -> expect(false).not_to be_false end,
          message: "Expected `false` not to be false but it is."
        }
      end

      it_behaves_like(CheckErrorSharedSpec)
    end
  end
end
