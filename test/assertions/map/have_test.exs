defmodule Map.HaveTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    defmodule TestStruct do
      defstruct [:foo]
    end

    let map: %{foo: "bar"}
    let struct: %TestStruct{foo: "bar"}

    context "Success" do
      it do: expect(map()).to(have({:foo, "bar"}))
      it do: expect(map()).to(have(foo: "bar"))
      it do: expect(map() |> to(have foo: "bar"))
      it do: expect(map()).to_not(have(4))

      it do: expect(struct()).to(have({:foo, "bar"}))
      it do: expect(struct()).to(have(foo: "bar"))
      it do: expect(struct()).to_not(have(4))
    end

    context "Error" do
      it do: expect(map()).to_not(have({:foo, "bar"}))
      it do: expect(map()).to_not(have(foo: "bar"))
      it do: expect(map()).to(have(4))

      it do: expect(struct()).to_not(have({:foo, "bar"}))
      it do: expect(struct()).to_not(have(foo: "bar"))
      it do: expect(struct()).to(have(4))
    end
  end

  setup_all do
    examples = ESpec.SuiteRunner.run_examples(SomeSpec.examples(), true)
    {:ok, success: Enum.slice(examples, 0, 6), errors: Enum.slice(examples, 7, 12)}
  end

  test "Success", context do
    Enum.each(context[:success], &assert(&1.status == :success))
  end

  test "Errors", context do
    Enum.each(context[:errors], &assert(&1.status == :failure))
  end
end
