defmodule String.HaveTest do

  use ExUnit.Case

  defmodule SomeSpec do
    use ESpec

    subject "qwerty"
  
    context "Success" do
      it do: should have("we")
      it do: should_not have("z")
    end

    context "Error" do
      it do: should_not have("qwe")
      it do: should have("zx")
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
