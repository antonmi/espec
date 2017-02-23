defmodule ESpec.Assertions.EqSpec do
  use ESpec, async: true

  describe "ESpec.Assertions.Eq" do
    context "Success" do
      it "checks success with `to`" do
        message = expect(1 + 1).to eq(2.0)
        expect(message) |> to(eq "`2` equals `2.0`.")
      end

      it "checks success with `not_to`" do
        message = expect(1 + 1).to_not eq(3)
        expect(message) |> to(eq "`2` doesn't equal `3`.")
      end
    end

    context "Errors" do
      context "with `to`" do
        before do
          {:shared,
            expectation: fn -> expect(1 + 1).to eq(3.0) end,
            message: "Expected (==) `3.0`, but got: `2`"}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with complex `to`" do
        before do
          {:shared,
            expectation: fn -> expect(%{a: 2, b: 3, c: 4}).to eq(%{a: 2, b: 4}) end,
            message: "Expected (==) `%{a: 2, b: 4}`, but \nhas extra: `[:c]`\nat [:b]:\n  got: `3`"}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      # context "with complex `to`" do
      #   subject do: %{a: 2, b: 3, c: 4}

      #   it do: should eq %{a: 2, b: 4}
      # end

      context "with `not_to`" do
        before do
          {:shared,
            expectation: fn -> expect(1 + 1).to_not eq(2) end,
            message: "Didn't expect (==) `2`, but got it"}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end
  end

  describe "be" do
    context "Success" do
      context "Success" do
        it "checks success with `to`" do
          message = expect(1 + 1 == 2).to be true
          expect(message) |> to(eq "`true` equals `true`.")
        end

        it "checks success with `not_to`" do
          message = expect(1 + 1 == 1).to_not be true
          expect(message) |> to(eq "`false` doesn't equal `true`.")
        end
      end

      it do: expect(1 + 1 == 1).to be false
      it do: expect(nil).to be nil
      it do: expect(1 + 1).to be 2
    end

    context "Errors" do
      context "with `to`" do
        before do
          {:shared,
            expectation: fn -> expect(2 + 2).to be 5 end,
            message: "Expected (==) `5`, but got: `4`"}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          {:shared,
            expectation: fn -> expect(1 + 1 == 1).to_not be false end,
            message: "Didn't expect (==) `false`, but got it"}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end
  end
end
