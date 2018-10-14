defmodule Binary.HaveByteSizeTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    let :byte_count, do: byte_size(binary())
    let :binary, do: <<116, 188, 252, 155, 9>>

    context "Success" do
      it do: expect(binary()) |> to(have_byte_size(byte_count()))
      it do: expect(binary()) |> to_not(have_byte_size(byte_count() - 1))
    end

    context "Error" do
      it do: expect(binary()) |> to_not(have_byte_size(byte_count()))
      it do: expect(binary()) |> to(have_byte_size(byte_count() - 1))
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
