defmodule ESpec.Assertions.BeCloseToSpec do
  use ESpec, async: true

  describe "ESpec.Assertions.BeCloseTo" do
    context "Success" do
      it "checks success with `to`" do
        message = expect(5).to be_close_to(4, 1)
        expect(message) |> to(eq "`5` is close to `4` with delta `1`.")
      end

      it "checks success with `not_to`" do
        message = expect(2).to_not be_close_to(5, 1)
        expect(message) |> to(eq "`2` is not close to `5` with delta `1`.")
      end

      it do: expect(5).to be_close_to(6, 1)
      it do: expect(5.5).to be_close_to(5.3, 0.21)
    end

    context "Errors" do
      context "with `to`" do
        before do
          {:shared,
            expectation: fn -> expect(2).to be_close_to(1, 0.9) end,
            message: "Expected `2` to be close to `1` with delta `0.9`, but it isn't."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          {:shared,
            expectation: fn -> expect(3).to_not be_close_to(3, 0) end,
            message: "Expected `3` not to be close to `3` with delta `0`, but it is."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end
  end
end
