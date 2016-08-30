defmodule List.BeErrorResultTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    let :error_result, do: {:error, :reason}
    let :ok_result, do: {:ok, :result}

    context "Success" do
      it do: expect error_result |> to(be_error_result)
      it do: expect ok_result |> not_to(be_error_result)
    end

    context "Errors" do
      it do: expect error_result |> not_to(be_error_result)
      it do: expect ok_result |> to(be_error_result)
    end
  end

  setup_all do
    examples = ESpec.Runner.run_examples(SomeSpec.examples, true)
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
