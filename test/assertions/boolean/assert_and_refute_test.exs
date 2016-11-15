defmodule Boolean.AssertAndRefuteTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec, async: true

    context "Success" do
      it do: ESpec.Assert.assert 1
      it do: ESpec.Assert.refute nil
    end

    context "Errors" do
      it do: ESpec.Assert.assert false
      it do: ESpec.Assert.refute "a"
    end
  end

  setup_all do
    examples = ESpec.SuiteRunner.run_examples(SomeSpec.examples, true)
    {:ok,
      success: Enum.slice(examples, 0, 1),
      errors: Enum.slice(examples, 2, 3)}
  end

  test "Success", context do
    Enum.each(context[:success], &(assert(&1.status == :success)))
  end

  test "Errors", context do
    Enum.each(context[:errors], &(assert(&1.status == :failure)))
  end
end
