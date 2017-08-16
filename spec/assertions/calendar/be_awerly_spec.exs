defmodule ESpec.Assertions.Calendar.BeAwarelySpec do
  use ESpec, async: true

  describe "ESpec.Assertions.Calendar.BeAwarely" do
    context "Success" do
      it "checks success with `to`" do
        message = expect(DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC")).to be_awarely :before, DateTime.from_naive!(~N[2017-01-02 10:00:00], "Etc/UTC")
        expect(message) |> to(eq "`#DateTime<2017-01-01 10:00:00Z> is before #DateTime<2017-01-02 10:00:00Z>` is true.")
      end

      it "checks success with `not_to`" do
        message = expect(DateTime.from_naive!(~N[2017-01-02 10:00:00], "Etc/UTC")).to_not be_awarely :after, DateTime.from_naive!(~N[2017-01-03 10:00:00], "Etc/UTC")
        expect(message) |> to(eq "`#DateTime<2017-01-02 10:00:00Z> is after #DateTime<2017-01-03 10:00:00Z>` is false.")
      end

      it do: expect(DateTime.from_naive!(~N[2017-01-02 10:00:00], "Etc/UTC")).to be_awarely :after, DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC")
      it do: expect(DateTime.from_naive!(~N[2017-01-02 10:00:00], "Etc/UTC")).to_not be_awarely :after, DateTime.from_naive!(~N[2017-01-03 10:00:00], "Etc/UTC")

      it do: expect(DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC")).to be_awarely :not_at, DateTime.from_naive!(~N[2017-01-02 10:00:00], "Etc/UTC")
      it do: expect(DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC")).to_not be_awarely :not_at, DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC")
    end

    context "Errors" do
      context "with `to`" do
        before do
          {:shared,
            expectation: fn -> expect(DateTime.from_naive!(~N[2017-01-02 10:00:00], "Etc/UTC")).to be_awarely :after, DateTime.from_naive!(~N[2017-01-03 10:00:00], "Etc/UTC") end,
            message: "Expected `#DateTime<2017-01-02 10:00:00Z> is after #DateTime<2017-01-03 10:00:00Z>` to be `true` but got `false`."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          {:shared,
            expectation: fn -> expect(DateTime.from_naive!(~N[2017-01-03 10:00:00], "Etc/UTC")).to_not be_awarely :before, DateTime.from_naive!(~N[2017-01-02 10:00:00], "Etc/UTC") end,
            message: "Expected `#DateTime<2017-01-02 10:00:00Z> is after #DateTime<2017-01-03 10:00:00Z>` to be `true` but got `false`."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end
  end
end
