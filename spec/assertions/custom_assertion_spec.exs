Code.require_file("spec/support/assertions/be_divisor_of_assertion.ex")
Code.require_file("spec/support/assertions/be_odd_assertion.ex")
Code.require_file("spec/support/assertions/custom_assertions.ex")

defmodule CustomAssertionSpec do
  use ESpec, async: true
  import CustomAssertions

  context "Success" do
    subject 3

    it "checks success with `to`" do
      message = should(be_divisor_of(6))
      expect(message) |> to(eq "`3` is the divisor of 6.")
    end

    it "checks success with `not_to`" do
      message = should_not(be_divisor_of(5))
      expect(message) |> to(eq "`3` is not the divisor of 5.")
    end

    it "checks success with `to`" do
      message = should(be_odd())
      expect(message) |> to(eq "`3` is odd number.")
    end

    it "checks success with `not_to`" do
      message = 2 |> should_not(be_odd())
      expect(message) |> to(eq "`2` is not odd number.")
    end
  end

  context "Error" do
    subject 5

    context "with `to`" do
      before do
        {:shared,
         expectation: fn -> should(be_divisor_of(6)) end,
         message: "Expected `5` to be the divisor of `6`, but the remainder is '1'."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        {:shared,
         expectation: fn -> should_not(be_divisor_of(5)) end,
         message: "Expected `5` not to be the divisor of `5`, but the remainder is '0'."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `to`" do
      before do
        {:shared,
         expectation: fn -> 2 |> should(be_odd()) end,
         message: "Expected `2` to be the odd number, but the remainder is '0'."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        {:shared,
         expectation: fn -> should_not(be_odd()) end,
         message: "Expected `5` not to be the odd number, but the remainder is '1'."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end
  end
end
