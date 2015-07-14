defmodule BeCloseToTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec
    
    context "Success" do
      it do: expect(5).to be_close_to(4, 1)
      it do: expect(5).to be_close_to(6, 1)
      it do: expect(5.5).to be_close_to(5.3, 0.21)
      it do: expect(2).to_not be_close_to(5, 1)
    end

    context "Errors" do
      it do: expect(2).to be_close_to(1, 0.9)
      it do: expect(3).to_not be_close_to(3, 0)
    end
  end

  setup_all do
    examples = ESpec.Runner.run_examples(SomeSpec.examples)
    { :ok,
      success: Enum.slice(examples, 0, 3),
      errors: Enum.slice(examples, 4, 5)
    }
  end

  test "Success", context do
    Enum.each(context[:success], &(assert(&1.status == :success)))
  end

  test "Errors", context do
    Enum.each(context[:errors], &(assert(&1.status == :failure)))
  end
end
