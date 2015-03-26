defmodule ThowTermTest do

  use ExUnit.Case

  defmodule SomeSpec do
    use ESpec
    let :func1, do: fn -> throw(:some_term) end
    let :func2, do: fn -> 1+1 end

    context "Success" do
      it do: expect(func1).to throw_term
      it do: expect(func1).to throw_term(:some_term)
      
      it do: expect(func1).not_to throw_term(:another_term)
    end

    context "Errors" do
      it do: expect(func2).to throw_term
      it do: expect(func2).to throw_term(:some_term)

      it do: expect(func1).to throw_term(:another_term)
      it do: expect(func1).not_to throw_term(:some_term)
    end

  end

  setup_all do
    examples = ESpec.Runner.run_examples(SomeSpec.examples, SomeSpec)
    { :ok,
      success: Enum.slice(examples, 0, 2),
      errors: Enum.slice(examples, 4, 6)
    }
  end

  test "Success", context do
    Enum.each(context[:success], fn(ex) ->
      assert(ex.success == true)
    end)
  end

  test "Errors", context do
    Enum.each(context[:errors], fn(ex) ->
      assert(ex.success == false)
    end)
  end

end
