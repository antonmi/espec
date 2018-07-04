defmodule ContainExactlyTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    context "Success" do
      it do: expect(a: 1, a: 1) |> to(contain_exactly(a: 1, a: 1))
      it do: expect(a: 1, b: 1) |> to(contain_exactly(b: 1, a: 1))
      it do: expect(a: 1, a: 1) |> not_to(contain_exactly(a: 1))
      it do: expect(a: 1, b: 1) |> not_to(contain_exactly(a: 1))
      it do: expect(nil) |> not_to(contain_exactly(a: 1))
    end

    context "Errors" do
      it do: expect(a: 1, a: 1) |> not_to(contain_exactly(a: 1, a: 1))
      it do: expect(a: 1, b: 1) |> not_to(contain_exactly(b: 1, a: 1))
      it do: expect(a: 1, a: 1) |> to(contain_exactly(a: 1))
      it do: expect(a: 1, b: 1) |> to(contain_exactly(a: 1))
      it do: expect(nil) |> to(contain_exactly(a: 1))
    end
  end

  setup_all do
    examples = ESpec.SuiteRunner.run_examples(SomeSpec.examples(), true)
    {:ok, success: Enum.slice(examples, 0, 4), errors: Enum.slice(examples, 5, 8)}
  end

  test "Success", context do
    Enum.each(context[:success], &assert(&1.status == :success))
  end

  test "Errors", context do
    Enum.each(context[:errors], &assert(&1.status == :failure))
  end
end
