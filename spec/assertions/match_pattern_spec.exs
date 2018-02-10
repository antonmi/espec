defmodule ESpec.Assertions.MatchPatternSpec do
  use ESpec, async: true

  describe "ESpec.Assertions.MatchPattern" do
    context "Success" do
      context "Success" do
        it "checks success with `to`" do
          message = expect({:ok, 1}).to match_pattern({:ok, _})
          expect(message) |> to(eq "`{:ok, 1}` matches pattern (=) `{:ok, _}`.")
        end

        it "checks success with `not_to`" do
          message = expect({:ok, 1}).to_not match_pattern({:error, _})
          expect(message) |> to(eq "`{:ok, 1}` doesn't match pattern (=) `{:error, _}`.")
        end
      end
    end

    context "Errors" do
      context "with `to`" do
        before do
          {:shared,
            expectation: fn -> expect({:ok, 1}).to match_pattern({:error, _}) end,
            message: "Expected `{:ok, 1}` to match pattern (=) `{:error, _}`, but it doesn't."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          {:shared,
            expectation: fn -> expect({:ok, 1}).to_not match_pattern({:ok, _}) end,
            message: "Expected `{:ok, 1}` not to match pattern (=) `{:ok, _}`, but it does."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end
  end
end
