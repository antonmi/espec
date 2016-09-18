defmodule ESpec.Assertions.String.BeValidSpec do
  use ESpec, async: true

  context "Success" do
    it "checks success with `to`" do
      message = "qwerty" |> should(be_valid_string())
      expect(message) |> to(eq "`\"qwerty\"` is valid.")
    end

    it "checks success with `not_to`" do
      message = <<0xffff :: 16>> |> should_not(be_valid_string())
      expect(message) |> to(eq "`<<255, 255>>` is not valid.")
    end
  end

  context "Error" do
    context "with `to`" do
      before do
        {:shared,
          expectation: fn -> <<0xffff :: 16>> |> should(be_valid_string()) end,
          message: "Expected `<<255, 255>>` to be valid but it isn't."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        {:shared,
          expectation: fn -> "qwerty" |> should_not(be_valid_string()) end,
          message: "Expected `\"qwerty\"` not to be valid but it is."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end
  end
end
