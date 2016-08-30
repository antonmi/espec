defmodule ESpec.Assertions.Boolean.BeTrueSpec do
  use ESpec, async: true

  context "Success" do
    it "checks success with `to`" do
      message = expect(true).to be_true
      expect(message) |> to(eq "`true` is true.")
    end

    it "checks success with `not_to`" do
      message = expect(1).to_not be_true
      expect(message) |> to(eq "`1` is not true.")
    end
  end

  context "Errors" do
    context "with `to`" do
      before do
        {:shared,
          expectation: fn -> expect(false).to be_true end,
          message: "Expected `false` to be true but it isn't."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        {:shared,
          expectation: fn -> expect(true).to_not be_true end,
          message: "Expected `true` not to be true but it is."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end
  end
end
