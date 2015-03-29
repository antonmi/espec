defmodule MatchTest do

  use ExUnit.Case

  defmodule SomeSpec do
    use ESpec
    context "Success" do
      it do: expect("abcd").to match(~r/c(d)/)
      it do: expect("abcd").to match("bc")
      it do: expect("abcd").to_not match(~r/e/)
      it do: expect("abcd").to_not match("ad")
    end

    context "Errors" do
      it do: expect("abcd").to_not match(~r/c(d)/)
      it do: expect("abcd").to_not match("bc")
      it do: expect("abcd").to match(~r/e/)
      it do: expect("abcd").to match("ad")
    end
  end

  setup_all do
    examples = ESpec.Runner.run_examples(SomeSpec.examples)
    { :ok,
      success: Enum.slice(examples, 0, 3),
      errors: Enum.slice(examples, 4, 7)
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
