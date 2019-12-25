defmodule ESpec.Assertions.ContainExactlySpec do
  use ESpec, async: true

  describe "ESpec.Assertions.ContainExactly" do
    context "Success" do
      it "checks success with `to`" do
        message = expect(a: 1, b: 2) |> to(contain_exactly(b: 2, a: 1))
        expect(message) |> to(eq "`[a: 1, b: 2]` contains exactly `[b: 2, a: 1]`.")
      end

      it "checks success with `not_to`" do
        message = expect(a: 1, b: 2) |> to_not(contain_exactly(a: 1, b: 3))
        expect(message) |> to(eq "`[a: 1, b: 2]` doesn't contain exactly `[a: 1, b: 3]`.")
      end

      it "checks success with `to`" do
        message = expect(a: 1, b: 2, c: 3) |> to(match_list(c: 3, a: 1, b: 2))
        expect(message) |> to(eq "`[a: 1, b: 2, c: 3]` contains exactly `[c: 3, a: 1, b: 2]`.")
      end

      it "checks success with `not_to`" do
        message = expect([:a, 1, :five, "x"]) |> to_not(match_list(["x", :a, :five, 5]))

        expect(message)
        |> to(eq "`[:a, 1, :five, \"x\"]` doesn't contain exactly `[\"x\", :a, :five, 5]`.")
      end

      it "checks success with `to`" do
        message =
          expect([{:a, 1}, 5, {:b, "16"}]) |> to(contain_exactly([{:b, "16"}, {:a, 1}, 5]))

        expect(message)
        |> to(eq "`[{:a, 1}, 5, {:b, \"16\"}]` contains exactly `[{:b, \"16\"}, {:a, 1}, 5]`.")
      end

      it "works with nil as subject" do
        expect(nil) |> not_to(match_list([]))
      end

      it "works with map as subject" do
        expect(%{a: 1}) |> not_to(match_list([1, 2, 3]))
      end

      it "works with number as subject" do
        expect(125) |> not_to(match_list([1, 2, 3]))
      end
    end

    context "Errors" do
      # it "looks nice" do
      #   expect([a: 1, c: 32, b: 2, b: 6, s: 8]).to match_list([a: 2, d: 4, b: 2, a: 5, b: 6, s: 8])
      # end
      #
      # it "looks nice again" do
      #   expect([a: 1, c: 32, b: 2, b: 68, s: 8, a: 1, c: 2, b: 789, bac: 6, s: 8, s: 88]).to match_list([a: 1, d: 4, c: 2, a: 5, b: 6, s: 8, a: 1, d: 4, b: 2, a: 5, b: 6, sA: 8, s: 89])
      # end
      #
      # it "looks nice as simple list" do
      #   expect([1, 2, 9, :a]).to match_list([2, 9, :a, 10])
      # end

      context "with `to`" do
        before do
          {:shared,
           expectation: fn -> expect([{:a, 1}, {:a, 1}, 2]) |> to(match_list([{:a, 1}, 2])) end,
           message:
             "Expected `[{:a, 1}, {:a, 1}, 2]` to contain exactly `[{:a, 1}, 2]`, but it doesn't."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          {:shared,
           expectation: fn -> expect([1, 2, 5]) |> not_to(contain_exactly([5, 2, 1])) end,
           message: "Expected `[1, 2, 5]` not to contain exactly `[5, 2, 1]`, but it does."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `to`" do
        before do
          {:shared,
           expectation: fn -> expect([1, 2, 2, 3, 3]) |> to(contain_exactly([1, 2, 3])) end,
           message: "Expected `[1, 2, 2, 3, 3]` to contain exactly `[1, 2, 3]`, but it doesn't."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          {:shared,
           expectation: fn ->
             expect([1, 2, 2, 3, 3]) |> not_to(contain_exactly([3, 1, 2, 2, 3]))
           end,
           message:
             "Expected `[1, 2, 2, 3, 3]` not to contain exactly `[3, 1, 2, 2, 3]`, but it does."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end
  end
end
