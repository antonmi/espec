defmodule ESpec.Assertions.Calendar.BeTimedSpec do
  use ESpec, async: true

  describe "ESpec.Assertions.Calendar.BeTimed" do
    context "Success" do
      it "checks success with `to`" do
        message = expect(~T[10:00:01]).to be_timed :after, ~T[10:00:00]
        expect(message) |> to(eq "`~T[10:00:01] is after ~T[10:00:00]` is true.")
      end

      it "checks success with `not_to`" do
        message = expect(~T[10:00:02]).to_not be_timed :after, ~T[10:00:03]
        expect(message) |> to(eq "`~T[10:00:02] is after ~T[10:00:03]` is false.")
      end
    end

    context "Errors" do
      context "with `to`" do
        before do
          {:shared,
            expectation: fn -> expect(~T[10:00:02]).to be_timed :after, ~T[10:00:03] end,
            message: "Expected `~T[10:00:02] is after ~T[10:00:03]` to be `true` but got `false`."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          {:shared,
            expectation: fn -> expect(~T[10:00:03]).to_not be_timed :before, ~T[10:00:01] end,
            message: "Expected `~T[10:00:03] is before ~T[10:00:01]` to be `false` but got `true`."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end
  end
end
