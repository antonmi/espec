defmodule ESpec.Assertions.Calendar.BeNaivelyBetweenSpec do
  use ESpec, async: true

  describe "ESpec.Assertions.Calendar.BeDatedBetween" do
    context "Success" do
      it "checks success with `to`" do
        message = expect(~N[2017-01-02 10:00:00]).to be_naively_between(~N[2017-01-01 10:00:00], ~N[2017-01-03 10:00:00])
        expect(message) |> to(eq "`~N[2017-01-02 10:00:00]` is between `~N[2017-01-01 10:00:00]` and `~N[2017-01-03 10:00:00]`.")
      end

      it "checks success with `not_to`" do
        message = expect(~N[2017-01-02 10:00:00]).to_not be_naively_between(~N[2017-01-03 10:00:00], ~N[2017-01-05 10:00:00])
        expect(message) |> to(eq "`~N[2017-01-02 10:00:00]` is not between `~N[2017-01-03 10:00:00]` and `~N[2017-01-05 10:00:00]`.")
      end
    end

    context "Errors" do
      context "with `to`" do
        before do
          {:shared,
            expectation: fn -> expect(~N[2017-01-02 10:00:00]).to be_naively_between(~N[2017-01-03 10:00:00], ~N[2017-01-05 10:00:00]) end,
            message: "Expected `~N[2017-01-02 10:00:00]` to be between `~N[2017-01-03 10:00:00]` and `~N[2017-01-05 10:00:00]`, but it isn't."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          {:shared,
            expectation: fn -> expect(~N[2017-01-02 10:00:00]).to_not be_naively_between(~N[2017-01-01 10:00:00], ~N[2017-01-03 10:00:00]) end,
            message: "Expected `~N[2017-01-02 10:00:00]` not to be between `~N[2017-01-01 10:00:00]` and `~N[2017-01-03 10:00:00]`, but it is."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end
  end
end
