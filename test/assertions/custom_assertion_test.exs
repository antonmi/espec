Code.require_file("spec/support/assertions/be_divisor_of_assertion.ex")
Code.require_file("spec/support/assertions/be_odd_assertion.ex")
Code.require_file("spec/support/assertions/custom_assertions.ex")

defmodule CustonAssertionTest do

  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec
    import CustomAssertions

    context "Success" do
      subject 3

      it do: should be_divisor_of(6)
      it do: should_not be_divisor_of(5)

      it do: should be_odd
      it do: 2 |> should_not be_odd
    end

    context "Error" do
      subject 5

      it do: should be_divisor_of(6)
      it do: should_not be_divisor_of(5)

      it do: should_not be_odd
      it do: 2 |> should be_odd
    end

  end


  setup_all do
    examples = ESpec.Runner.run_examples(SomeSpec.examples)
    { :ok,
      success: Enum.slice(examples, 0, 3),
      errors: Enum.slice(examples, 4, 7)
    }
  end

  test "Success", context do
    Enum.each(context[:success], fn(ex) ->
      assert(ex.status == :success)
    end)
  end

  test "Errors", context do
    Enum.each(context[:errors], fn(ex) ->
      assert(ex.status == :failure)
    end)
  end
end