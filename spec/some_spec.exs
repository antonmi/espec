defmodule SomeSpec do
  
  use ESpec

  def add(value), do: Agent.update(:some_spec_agent, &(Set.put(&1, :a)))
  def count, do: length(Agent.get(:some_spec_agent, &(&1)) |> Set.to_list)

  before do: Agent.start_link(fn -> HashSet.new end, name: :some_spec_agent) 
  finally do: Agent.stop(:some_spec_agent)

  it "change to" do
    f1 = fn -> SomeSpec.add(:value) end
    f2 = &SomeSpec.count/0
    expect(f1).to change(f2, 1)    
  end

  it "change from to" do
    f1 = fn -> SomeSpec.add(:value) end
    f2 = &SomeSpec.count/0
    expect(f1).to change(f2, 0, 1)    
  end


end 