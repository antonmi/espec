defmodule ESpec.Assertions.Calendar.BeDatedBetweenSpec do
  use ESpec, async: true

  describe "ESpec.Assertions.Calendar.BeDatedBetween" do
    context "Success" do
      it "checks success with `to`" do
        message = expect(~D[2017-01-02]).to be_dated_between(~D[2017-01-01], ~D[2017-01-03])
        expect(message) |> to(eq "`~D[2017-01-02]` is between `~D[2017-01-01]` and `~D[2017-01-03]`.")
      end

      it "checks success with `not_to`" do
        message = expect(~D[2017-01-02]).to_not be_dated_between(~D[2017-01-03], ~D[2017-01-05])
        expect(message) |> to(eq "`~D[2017-01-02]` is not between `~D[2017-01-03]` and `~D[2017-01-05]`.")
      end
    end

    context "Errors" do
      context "with `to`" do
        before do
          {:shared,
            expectation: fn -> expect(~D[2017-01-02]).to be_dated_between(~D[2017-01-03], ~D[2017-01-05]) end,
            message: "Expected `~D[2017-01-02]` to be between `~D[2017-01-03]` and `~D[2017-01-05]`, but it isn't."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          {:shared,
            expectation: fn -> expect(~D[2017-01-02]).to_not be_dated_between(~D[2017-01-01], ~D[2017-01-03]) end,
            message: "Expected `~D[2017-01-02]` not to be between `~D[2017-01-01]` and `~D[2017-01-03]`, but it is."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end
  end
end
