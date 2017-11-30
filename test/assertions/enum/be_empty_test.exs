defmodule Enum.BeEmptyTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    context "Success" do
      it do: expect([]).to be_empty()
      it do: expect([1, 2, 3]).to_not be_empty()
      it do: expect("").to be_empty()
      it do: expect("qwerty").to_not be_empty()
    end

    context "Error" do
      it do: expect([]).to_not be_empty()
      it do: expect([1, 2, 3]).to be_empty()
      it do: expect("").to_not be_empty()
      it do: expect("qwerty").to be_empty()
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
