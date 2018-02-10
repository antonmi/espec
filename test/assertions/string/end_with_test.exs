defmodule String.EndWithTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    subject "qwerty"

    context "Success" do
      it do: should end_with "rty"
      it do: should_not end_with "ert"
    end

    context "Short string" do
      subject "q"
      context "Success" do
        it do: should end_with "q"
        it do: should_not end_with "ert"
      end
    end

    context "Error" do
      it do: should_not end_with "rty"
      it do: should end_with "ert"
    end

    context "Short string" do
      subject "q"
      context "Error" do
        it do: should_not end_with "q"
        it do: should end_with "e"
      end
    end
  end

  setup_all do
    examples = ESpec.SuiteRunner.run_examples(SomeSpec.examples, true)
    {:ok,
      success: Enum.slice(examples, 0, 3),
      errors: Enum.slice(examples, 4, 7)}
  end

  test "Success", context do
    Enum.each(context[:success], &(assert(&1.status == :success)))
  end

  test "Errors", context do
    Enum.each(context[:errors], &(assert(&1.status == :failure)))
  end
end
