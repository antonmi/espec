defmodule ESpec.Assertions.BeSpec do
  use ESpec, async: true

  describe "ESpec.Assertions.Be" do
    context "Success" do
      it "checks success with `to`" do
        message = expect(2) |> to(be(:>, 1))
        expect(message) |> to(eq("`2 > 1` is true."))
      end

      it "checks success with `not_to`" do
        message = expect(2) |> to_not(be(:>, 3))
        expect(message) |> to(eq("`2 > 3` is false."))
      end

      it(do: expect(1) |> to(be(:!=, 2)))
      it(do: expect(1) |> to_not(be(:!=, 1)))

      it(do: expect(1) |> to(be(:<=, 1)))
      it(do: expect("abcd") |> to(be(:=~, ~r/c(d)/)))
    end

    context "Errors" do
      context "with `to`" do
        before do
          {:shared,
           expectation: fn -> expect(2) |> to(be(:>, 3)) end,
           message: "Expected `2 > 3` to be `true` but got `false`."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          {:shared,
           expectation: fn -> expect(1) |> to_not(be(:==, 1.0)) end,
           message: "Expected `1 == 1.0` to be `false` but got `true`."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end
  end
end
