defmodule Enum.BeEmptyTest do

  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec
    
    context "Success" do
      it do: expect([]).to be_empty
      it do: expect([1,2,3]).to_not be_empty
    end

    context "Error" do
      it do: expect([]).to_not be_empty
      it do: expect([1,2,3]).to be_empty
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
    Enum.each(context[:success], fn(ex) ->
      assert(ex.status == :success)
    end)
  end

  test "Errors", context do
    Enum.each(context[:errors], fn(ex) ->
      assert(ex.status == :failure)
    end)
  end

end
