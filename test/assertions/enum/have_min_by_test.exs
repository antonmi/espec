defmodule Enum.HaveMinByTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    let :range, do: 1..3
    let :func, do: fn el -> 10 / el end

    context "Success" do
      it do: expect(range()).to(have_min_by(func(), 3))
      it do: expect(range()).to_not(have_min_by(func(), 1))
    end

    context "Error" do
      it do: expect(range()).to_not(have_min_by(func(), 3))
      it do: expect(range()).to(have_min_by(func(), 1))
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
