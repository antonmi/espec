defmodule String.HaveCountTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    subject "qwerty"
  
    context "Success" do
      it do: should have_count(6)
      it do: should_not have_count(3)
    end

    context "aliases" do
      it do: should have_size(3)
      it do: should have_length(3)
    end

    context "Error" do
      it do: should_not have_count(6)
      it do: should have_count(3)
    end
  end

  setup_all do
    examples = ESpec.Runner.run_examples(SomeSpec.examples)
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
