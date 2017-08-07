defmodule ESpec.Assertions.Date.BeDateSpec do
  use ESpec, async: true

  context "Success" do
    it "checks success with `to`" do
      date = ~D[2001-01-01] |> should(be_date())
      expect(date) |> to(eq "`~D[2001-01-01]` is a Date.")
    end

    it "checks success with `not_to`" do
      date = "qwerty" |> should_not(be_date())
      expect(date) |> to(eq "`\"qwerty\"` is not a Date.")
    end
  end

  context "Error" do
    context "with `to`" do
      before do
        {:shared,
          expectation: fn -> "qwerty" |> should(be_date()) end,
          message: "Expected `\"qwerty\"` to be a Date but it isn't."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        {:shared,
          expectation: fn -> ~D[2001-01-01] |> should_not(be_date()) end,
          message: "Expected `~D[2001-01-01]` not to be a Date but it is."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end
  end
end
