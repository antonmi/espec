defmodule ESpec.Assertions.String.BeBlankSpec do
  use ESpec, async: true

  context "Success" do
    it "checks success with `to`" do
      message = "" |> should(be_blank)
      expect(message) |> to(eq "`\"\"` is blank.")
    end

    it "checks success with `not_to`" do
      message = "qwerty" |> should_not(be_blank)
      expect(message) |> to(eq "`\"qwerty\"` is not blank.")
    end
  end

  context "Error" do
    context "with `to`" do
      before do
        {:shared,
          expectation: fn -> "qwerty" |> should(be_blank) end,
          message: "Expected `\"qwerty\"` to be blank but it isn't."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        {:shared,
          expectation: fn -> "" |> should_not(be_blank) end,
          message: "Expected `\"\"` not to be blank but it is."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end
  end
end
