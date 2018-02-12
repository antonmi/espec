defmodule String.StartWithTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    subject "qwerty"

    context "Success" do
      it do: should(start_with "qwe")
      it do: should_not(start_with "ert")
    end

    context "Short string" do
      subject "q"

      context "Success" do
        it do: should(start_with "q")
        it do: should_not(start_with "ert")
      end
    end

    context "Error" do
      it do: should_not(start_with "qwe")
      it do: should(start_with "ert")
    end

    context "Short string" do
      context "Error" do
        it do: should_not(start_with "qw")
        it do: should(start_with "e")
      end
    end
  end

  setup_all do
    examples = ESpec.SuiteRunner.run_examples(SomeSpec.examples(), true)
    {:ok, success: Enum.slice(examples, 0, 3), errors: Enum.slice(examples, 4, 7)}
  end

  test "Success", context do
    Enum.each(context[:success], &assert(&1.status == :success))
  end

  test "Errors", context do
    Enum.each(context[:errors], &assert(&1.status == :failure))
  end
end
