defmodule ESpec.Assertions.String.BePrintableSpec do
  use ESpec, async: true

  context "Success" do
    it "checks success with `to`" do
      message = "qwerty" |> should(be_printable())
      expect(message) |> to(eq "`\"qwerty\"` is printable.")
    end

    it "checks success with `not_to`" do
      message = <<1, 2, 3>> |> should_not(be_printable())
      expect(message) |> to(eq "`<<1, 2, 3>>` is not printable.")
    end
  end

  context "Error" do
    context "with `to`" do
      before do
        {:shared,
         expectation: fn -> <<1, 2, 3>> |> should(be_printable()) end,
         message: "Expected `<<1, 2, 3>>` to be printable but it isn't."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        {:shared,
         expectation: fn -> "qwerty" |> should_not(be_printable()) end,
         message: "Expected `\"qwerty\"` not to be printable but it is."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end
  end
end
