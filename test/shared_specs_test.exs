defmodule SharedSpecsTest do
  use ExUnit.Case, async: true

  defmodule SharedSpec do
    use ESpec, shared: true

    before do: {:ok, c: __.b + 1}

    let! :c, do: __.c

    context "SharedSpec context" do
      let :d, do: __.c + 1

      it do: expect(__.a).to eq(1)
      it do: expect(__.b).to eq(2)
      it do: expect(c).to eq(3)
      it do: expect(d).to eq(4)
    end
  end

  defmodule UseSharedSpecSpec do
    use ESpec
    
    before do: {:ok, a: 1}

    context "SomeSpec context" do
      before do: {:ok, b: 2}

      it_behaves_like(SharedSpec)
    end
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
