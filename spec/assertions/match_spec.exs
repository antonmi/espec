defmodule ESpec.Assertions.MatchSpec do
  use ESpec, async: true

  describe "ESpec.Assertions.Match" do
    context "Success" do
      it "checks success with `to`" do
        message = expect("abcd").to match(~r/c(d)/)
        expect(message) |> to(eq "`\"abcd\"` matches (=~) `~r/c(d)/`.")
      end

      it "checks success with `not_to`" do
        message = expect("abcd").to_not match(~r/e/)
        expect(message) |> to(eq "`\"abcd\"` doesn't match (=~) `~r/e/`.")
      end

      it "checks success with `to`" do
        message = expect("abcd").to match("bc")
        expect(message) |> to(eq "`\"abcd\"` matches (=~) `\"bc\"`.")
      end

      it "checks success with `not_to`" do
        message = expect("abcd").to_not match("ad")
        expect(message) |> to(eq "`\"abcd\"` doesn't match (=~) `\"ad\"`.")
      end
    end

    context "Errors" do
      context "with `to`" do
        before do
          { :shared,
            expectation: fn -> expect("abcd").to match(~r/e/) end,
            message: "Expected `\"abcd\"` to match (=~) `~r/e/`, but it doesn't."
          }
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          { :shared,
            expectation: fn -> expect("abcd").to_not match(~r/c(d)/) end,
            message: "Expected `\"abcd\"` not to match (=~) `~r/c(d)/`, but it does."
          }
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `to`" do
        before do
          { :shared,
            expectation: fn -> expect("abcd").to match("ad") end,
            message: "Expected `\"abcd\"` to match (=~) `\"ad\"`, but it doesn't."
          }
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          { :shared,
            expectation: fn -> expect("abcd").to_not match(~r/c(d)/) end,
            message: "Expected `\"abcd\"` not to match (=~) `~r/c(d)/`, but it does."
          }
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end
  end
end
