defmodule ChangeTest do

  use ExUnit.Case

  defmodule SomeSpec do
    use ESpec

    def add(value), do: Agent.update(:some_spec_agent, &(Set.put(&1, value)))
    def count, do: length(Agent.get(:some_spec_agent, &(&1)) |> Set.to_list)

    before do: Agent.start_link(fn -> HashSet.new end, name: :some_spec_agent) 
    finally do: Agent.stop(:some_spec_agent)

    let :f1, do: fn -> ChangeTest.SomeSpec.add(:value) end
    let :f2, do: &ChangeTest.SomeSpec.count/0 

    context "Success" do
      it "change_to", do: expect(f1).to change(f2, 1)    
      it "change_from_to", do: expect(f1).to change(f2, 0, 1)    
    end

    context "Error" do
      it "change_to", do: expect(f1).to change(f2, 2)    
      it "change_from_to", do: expect(f1).to change(f2, 0, 2)    
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