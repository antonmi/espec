defmodule ESpec.Assertions.Boolean.BeFalsySpec do
  use ESpec, async: true

  context "Success" do
    it "checks success with `to`" do
      message = expect(nil).to be_falsy
      expect(message) |> to(eq "`nil` is falsy.")
    end

    it "checks success with `not_to`" do
      message = expect(1).to_not be_falsy
      expect(message) |> to(eq "`1` is not falsy.")
    end
  end

  context "Errors" do
    context "with `to`" do
      before do
        { :shared,
          expectation: fn -> expect(true).to be_falsy end,
          message: "Expected `true` to be falsy but it isn't."
        }
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        { :shared,
          expectation: fn -> expect(false).to_not be_falsy end,
          message: "Expected `false` not to be falsy but it is."
        }
      end

      it_behaves_like(CheckErrorSharedSpec)
    end
  end
end
