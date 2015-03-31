defmodule List.HaveLastTest do

  use ExUnit.Case

  defmodule SomeSpec do
    use ESpec

    subject [1,2,3]
  
    context "Success" do
      it do: should have_last 3
     it do: should_not have_last 2
   end

    context "Error" do
      it do: should_not have_last 3
      it do: should have_last 2
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
