defmodule ESpec.Assertions.Calendar.BeNaivelySpec do
  use ESpec, async: true

  describe "ESpec.Assertions.Calendar.BeNaively" do
    context "Success" do
      it "checks success with `to`" do
        message = expect(~N[2017-01-01 10:00:00]).to be_naively :before, ~N[2017-01-02 10:00:00]
        expect(message) |> to(eq "`~N[2017-01-01 10:00:00] is before ~N[2017-01-02 10:00:00]` is true.")
      end

      it "checks success with `not_to`" do
        message = expect(~N[2017-01-02 10:00:00]).to_not be_naively :after, ~N[2017-01-03 10:00:00]
        expect(message) |> to(eq "`~N[2017-01-02 10:00:00] is after ~N[2017-01-03 10:00:00]` is false.")
      end

      it do: expect(~N[2017-01-02 10:00:00]).to be_naively :after, ~N[2017-01-01 10:00:00]
      it do: expect(~N[2017-01-02 10:00:00]).to_not be_naively :after, ~N[2017-01-03 10:00:00]

      it do: expect(~N[2017-01-01 10:00:00]).to be_naively :not_at, ~N[2017-01-02 10:00:00]
      it do: expect(~N[2017-01-01 10:00:00]).to_not be_naively :not_at, ~N[2017-01-01 10:00:00]
    end

    context "Errors" do
      context "with `to`" do
        before do
          {:shared,
            expectation: fn -> expect(~N[2017-01-02 10:00:00]).to be_naively :after, ~N[2017-01-03 10:00:00] end,
            message: "Expected `~N[2017-01-02 10:00:00] is after ~N[2017-01-03 10:00:00]` to be `true` but got `false`."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          {:shared,
            expectation: fn -> expect(~N[2017-01-03 10:00:00]).to_not be_naively :before, ~N[2017-01-02 10:00:00] end,
            message: "Expected `~N[2017-01-03 10:00:00] is before ~N[2017-01-02 10:00:00]` to be `false` but got `true`."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end
  end
end
