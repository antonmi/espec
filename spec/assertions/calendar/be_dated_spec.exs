defmodule ESpec.Assertions.Calendar.BeDatedSpec do
  use ESpec, async: true

  describe "ESpec.Assertions.Calendar.BeDated" do
    context "Success" do
      it "checks success with `to`" do
        message = expect(~D[2017-01-01]).to be_dated :before, ~D[2017-01-02]
        expect(message) |> to(eq "`~D[2017-01-01] is before ~D[2017-01-02]` is true.")
      end

      it "checks success with `not_to`" do
        message = expect(~D[2017-01-02]).to_not be_dated :after, ~D[2017-01-03]
        expect(message) |> to(eq "`~D[2017-01-02] is after ~D[2017-01-03]` is false.")
      end

      it do: expect(~D[2017-01-02]).to be_dated :after, ~D[2017-01-01]
      it do: expect(~D[2017-01-02]).to_not be_dated :after, ~D[2017-01-03]

      it do: expect(~D[2017-01-01]).to be_dated :not_at, ~D[2017-01-02]
      it do: expect(~D[2017-01-01]).to_not be_dated :not_at, ~D[2017-01-01]
    end

    context "Errors" do
      context "with `to`" do
        before do
          {:shared,
            expectation: fn -> expect(~D[2017-01-02]).to be_dated :after, ~D[2017-01-03] end,
            message: "Expected `~D[2017-01-02] is after ~D[2017-01-03]` to be `true` but got `false`."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          {:shared,
            expectation: fn -> expect(~D[2017-01-03]).to_not be_dated :before, ~D[2017-01-02] end,
            message: "Expected `~D[2017-01-03] is before ~D[2017-01-02]` to be `false` but got `true`."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end
  end
end
