defmodule LetSharedSpecsTest do
  use ExUnit.Case, async: true

  defmodule SharedSpec do
    use ESpec, shared: true, async: true

    let_overridable a: 10, b: 20
    let_overridable [:c, :d]
    let_overridable :e

    let :qqq, do: :qqq

    it do: expect(a).to eq(1)
    it do: expect(b).to eq(20)
    it do: expect(c).to eq(3)

    it do: expect(d).to eq(nil)
    it do: expect(e).to eq(nil)

    it do: expect(qqq).to eq(:qqq)
  end

  defmodule UseSharedSpecSpec do
    use ESpec

    let :a, do: 1
    let :c, do: 3
    let :qqq, do: :www

    it_behaves_like(SharedSpec)
    include_examples(SharedSpec)
  end

  setup_all do
    examples = ESpec.Runner.run_examples(UseSharedSpecSpec.examples)
    { :ok, examples: examples }
  end

  test "Examples should pass", context do
    Enum.each(context[:examples], fn(ex) ->
      assert(ex.status == :success)
    end)
  end
end
