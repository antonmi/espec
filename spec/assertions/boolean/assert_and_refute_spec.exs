defmodule ESpec.Assertions.Boolean.AssertAndRefuteSpec do
  use ESpec, async: true

  context "Success" do
    it "checks success with `to`" do
      message = assert 1
      expect(message) |> to(eq "`1` is truthy.")
    end

    it "checks success with `not_to`" do
      message = refute nil
      expect(message) |> to(eq "`nil` is falsy.")
    end
  end

  context "Errors" do
    context "with `to`" do
      before do
        {:shared,
         expectation: fn -> assert false end,
         message: "Expected `false` to be truthy but it isn't."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        {:shared,
         expectation: fn -> refute "a" end, message: "Expected `\"a\"` to be falsy but it isn't."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end
  end
end
