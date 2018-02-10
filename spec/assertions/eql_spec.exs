defmodule ESpec.Assertions.EqlSpec do
  use ESpec, async: true

  describe "ESpec.Assertions.Eql" do
    context "Success" do
      context "Success" do
        it "checks success with `to`" do
          message = expect(1 + 1).to eql(2)
          expect(message) |> to(eq "`2` equals `2`.")
        end

        it "checks success with `not_to`" do
          message = expect(1 + 1).to_not eql(2.0)
          expect(message) |> to(eq "`2` doesn't equal `2.0`.")
        end
      end
    end

    context "Errors" do
      context "with `to`" do
        before do
          {:shared,
            expectation: fn -> expect(1 + 1).to eql(2.0) end,
            message: "Expected `2` to equal (===) `2.0`, but it doesn't."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          {:shared,
            expectation: fn -> expect(1 + 1).to_not eql(2) end,
            message: "Expected `2` not to equal (===) `2`, but it does."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end
  end
end
