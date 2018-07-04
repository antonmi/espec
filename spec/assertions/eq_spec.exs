defmodule ESpec.Assertions.EqSpec do
  use ESpec, async: true

  describe "ESpec.Assertions.Eq" do
    context "Success" do
      it "checks success with `to`" do
        message = expect(1 + 1) |> to(eq(2.0))
        expect(message) |> to(eq "`2` equals `2.0`.")
      end

      it "checks success with `not_to`" do
        message = expect(1 + 1) |> to_not(eq(3))
        expect(message) |> to(eq "`2` doesn't equal `3`.")
      end
    end

    context "Errors" do
      context "with `to`" do
        before do
          {:shared,
           expectation: fn -> expect(1 + 1) |> to(eq(3.0)) end,
           message: "Expected `2` to equal (==) `3.0`, but it doesn't.",
           extra: true}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with complex `to`" do
        before do
          {:shared,
           expectation: fn -> expect(%{a: 2, b: 3, c: 4}) |> to(eq(%{a: 2, b: 4})) end,
           message:
             "Expected `%{a: 2, b: 3, c: 4}` to equal (==) `%{a: 2, b: 4}`, but it doesn't.",
           extra: true}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          {:shared,
           expectation: fn -> expect(1 + 1) |> to_not(eq(2)) end,
           message: "Expected `2` not to equal (==) `2`, but it does.",
           extra: false}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end
  end

  describe "be" do
    context "Success" do
      context "Success" do
        it "checks success with `to`" do
          message = expect(1 + 1 == 2) |> to(be true)
          expect(message) |> to(eq "`true` equals `true`.")
        end

        it "checks success with `not_to`" do
          message = expect(1 + 1 == 1) |> to_not(be true)
          expect(message) |> to(eq "`false` doesn't equal `true`.")
        end
      end

      it do: expect(1 + 1 == 1) |> to(be false)
      it do: expect(nil) |> to(be nil)
      it do: expect(1 + 1) |> to(be 2)
    end

    context "Errors" do
      context "with `to`" do
        before do
          {:shared,
           expectation: fn -> expect(2 + 2) |> to(be 5) end,
           message: "Expected `4` to equal (==) `5`, but it doesn't.",
           extra: true}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          {:shared,
           expectation: fn -> expect(1 + 1 == 1) |> to_not(be false) end,
           message: "Expected `false` not to equal (==) `false`, but it does.",
           extra: false}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end
  end
end
