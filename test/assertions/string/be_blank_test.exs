defmodule String.BeBlankTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    subject "qwerty"

    context "Success" do
      it do: "" |> should(be_blank())
      it do: "qwerty" |> should_not(be_blank())
    end

    context "Error" do
      it do: "" |> should_not(be_blank())
      it do: "qwerty" |> should(be_blank())
    end
  end

  setup_all do
    examples = ESpec.SuiteRunner.run_examples(SomeSpec.examples(), true)
    {:ok, success: Enum.slice(examples, 0, 1), errors: Enum.slice(examples, 2, 3)}
  end

  test "Success", context do
    Enum.each(context[:success], &assert(&1.status == :success))
  end

  test "Errors", context do
    Enum.each(context[:errors], &assert(&1.status == :failure))
  end
end
