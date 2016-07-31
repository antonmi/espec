defmodule Boolean.BeFalseTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec, async: true

    context "Success" do
      it do: expect(false).to be_false
      it do: expect(1).to_not be_false
    end

    context "Errors" do
      it do: expect(true).to be_false
      it do: expect(false).to_not be_false
    end
  end

  setup_all do
    examples = ESpec.Runner.run_examples(SomeSpec.examples, true)
    { :ok,
      success: Enum.slice(examples, 0, 1),
      errors: Enum.slice(examples, 2, 3)
    }
  end

  test "Success", context do
    Enum.each(context[:success], &(assert(&1.status == :success)))
  end

  test "Errors", context do
    Enum.each(context[:errors], &(assert(&1.status == :failure)))
  end
end
