defmodule ESpec.Assertions.Boolean.BeTruthySpec do
  use ESpec, async: true

  context "Success" do
    it "checks success with `to`" do
      message = expect(1) |> to(be_truthy())
      expect(message) |> to(eq "`1` is truthy.")
    end

    it "checks success with `not_to`" do
      message = expect(nil) |> to_not(be_truthy())
      expect(message) |> to(eq "`nil` is not truthy.")
    end
  end

  context "Errors" do
    context "with `to`" do
      before do
        {:shared,
         expectation: fn -> expect false |> to(be_truthy()) end,
         message: "Expected `false` to be truthy but it isn't."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        {:shared,
         expectation: fn -> expect(true) |> to_not(be_truthy()) end,
         message: "Expected `true` not to be truthy but it is."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end
  end
end
