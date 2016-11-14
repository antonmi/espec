defmodule LetSharedSpecsTest do
  use ExUnit.Case, async: true

  defmodule SharedSpec do
    use ESpec, shared: true, async: true

    let_overridable a: 10, b: 20
    let_overridable [:c, :d]
    let_overridable :e

    let :qqq, do: :qqq

    it do: expect(a()).to eq(1)
    it do: expect(b()).to eq(20)
    it do: expect(c()).to eq(3)

    it do: expect(d()).to eq(nil)
    it do: expect(e()).to eq(nil)

    it do: expect(qqq()).to eq(:qqq)
  end

  defmodule UseSharedSpecSpec do
    use ESpec

    let :a, do: 1
    let :c, do: 3
    let :qqq, do: :www

    it_behaves_like(SharedSpec)
    include_examples(SharedSpec)
  end

  defmodule UseLetSharedAsKeywordSpec do
    use ESpec

    it_behaves_like(SharedSpec, a: 1, c: 3, qqq: :www)
    include_examples(SharedSpec, a: 1, c: 3, qqq: :www)
  end

  setup_all do
    examples1 = ESpec.SuiteRunner.run_examples(UseSharedSpecSpec.examples, true)
    examples2 = ESpec.SuiteRunner.run_examples(UseLetSharedAsKeywordSpec.examples, true)
    {:ok, examples: examples1 ++ examples2}
  end

  test "Examples should pass", context do
    Enum.each(context[:examples], fn(ex) ->
      assert(ex.status == :success)
    end)
  end
end
