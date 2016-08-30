defmodule ESpec.Assertions.BetweenSpec do
  use ESpec, async: true

  describe "ESpec.Assertions.Between" do
    context "Success" do
      it "checks success with `to`" do
        message = expect(1 + 1).to be_between(1, 3)
        expect(message) |> to(eq "`2` is be between `1` and `3`.")
      end

      it "checks success with `not_to`" do
        message = expect(1 + 1).to_not be_between(3, 5)
        expect(message) |> to(eq "`2` is not be between `3` and `5`.")
      end
    end

    context "Errors" do
      context "with `to`" do
        before do
          {:shared,
            expectation: fn -> expect(1 + 1).to be_between(3, 5) end,
            message: "Expected `2` to be between `3` and `5`, but it isn't."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          {:shared,
            expectation: fn -> expect(1 + 1).to_not be_between(1,3) end,
            message: "Expected `2` not to be between `1` and `3`, but it is."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end
  end
end
