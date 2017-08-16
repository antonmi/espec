defmodule ESpec.Assertions.Calendar.BeAwarelyBetweenSpec do
  use ESpec, async: true

  describe "ESpec.Assertions.Calendar.BeDatedBetween" do
    context "Success" do
      it "checks success with `to`" do
        message = expect(DateTime.from_naive!(~N[2017-01-02 10:00:00], "Etc/UTC")).to be_awarely_between(DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC"), DateTime.from_naive!(~N[2017-01-03 10:00:00], "Etc/UTC"))
        expect(message) |> to(eq "`#DateTime<2017-01-02 10:00:00Z>` is between `#DateTime<2017-01-01 10:00:00Z>` and `#DateTime<2017-01-03 10:00:00Z>`.")
      end

      it "checks success with `not_to`" do
        message = expect(DateTime.from_naive!(~N[2017-01-02 10:00:00], "Etc/UTC")).to_not be_awarely_between(DateTime.from_naive!(~N[2017-01-03 10:00:00], "Etc/UTC"), DateTime.from_naive!(~N[2017-01-05 10:00:00], "Etc/UTC"))
        expect(message) |> to(eq "`#DateTime<2017-01-02 10:00:00Z>` is not between `#DateTime<2017-01-03 10:00:00Z>` and `#DateTime<2017-01-05 10:00:00Z>`.")
      end
    end

    context "Errors" do
      context "with `to`" do
        before do
          {:shared,
            expectation: fn -> expect(DateTime.from_naive!(~N[2017-01-02 10:00:00], "Etc/UTC")).to be_awarely_between(DateTime.from_naive!(~N[2017-01-03 10:00:00], "Etc/UTC"), DateTime.from_naive!(~N[2017-01-05 10:00:00], "Etc/UTC")) end,
            message: "Expected `#DateTime<2017-01-02 10:00:00Z>` to be between `#DateTime<2017-01-03 10:00:00Z>` and `#DateTime<2017-01-05 10:00:00Z>`, but it isn't."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          {:shared,
            expectation: fn -> expect(DateTime.from_naive!(~N[2017-01-02 10:00:00], "Etc/UTC")).to_not be_awarely_between(DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC"), DateTime.from_naive!(~N[2017-01-03 10:00:00], "Etc/UTC")) end,
            message: "Expected `#DateTime<2017-01-02 10:00:00Z>` not to be between `#DateTime<2017-01-01 10:00:00Z>` and `#DateTime<2017-01-03 10:00:00Z>`, but it is."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end
  end
end
