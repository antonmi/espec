Code.require_file("spec/support/assertions/be_divisor_of_assertion.ex")
Code.require_file("spec/support/assertions/be_odd_assertion.ex")
Code.require_file("spec/support/assertions/custom_assertions.ex")

defmodule CustomAssertionSpec do
  use ESpec, async: true
  import CustomAssertions

  context "Success" do
    subject 3

    it do: should be_divisor_of(6)
    it do: should_not be_divisor_of(5)

    it do: should be_odd
    it do: 2 |> should_not be_odd
  end

  xcontext "Error" do
    subject 5

    it do: should be_divisor_of(6)
    it do: should_not be_divisor_of(5)

    it do: should_not be_odd
    it do: 2 |> should be_odd
  end
end
