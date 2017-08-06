defmodule ESpec.Assertions.Calendar.BeTimedBetweenSpec do
  use ESpec, async: true

  describe "ESpec.Assertions.Calendar.BeTimedBetween" do
    context "Success" do
      it "checks success with `to`" do
        message = expect(~T[10:00:02]).to be_timed_between(~T[10:00:01], ~T[10:00:03])
        expect(message) |> to(eq "`~T[10:00:02]` is between `~T[10:00:01]` and `~T[10:00:03]`.")
      end

      it "checks success with `not_to`" do
        message = expect(~T[10:00:02]).to_not be_timed_between(~T[10:00:03], ~T[10:00:05])
        expect(message) |> to(eq "`~T[10:00:02]` is not between `~T[10:00:03]` and `~T[10:00:05]`.")
      end
    end

    context "Errors" do
      context "with `to`" do
        before do
          {:shared,
            expectation: fn -> expect(~T[10:00:02]).to be_timed_between(~T[10:00:03], ~T[10:00:05]) end,
            message: "Expected `~T[10:00:02]` to be between `~T[10:00:03]` and `~T[10:00:05]`, but it isn't."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          {:shared,
            expectation: fn -> expect(~T[10:00:02]).to_not be_timed_between(~T[10:00:01], ~T[10:00:03]) end,
            message: "Expected `~T[10:00:02]` not to be between `~T[10:00:01]` and `~T[10:00:03]`, but it is."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end
  end
end
