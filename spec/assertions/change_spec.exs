defmodule ChangeSpec do
  use ESpec

  def add(value), do: Agent.update(:some_spec_agent, &(Set.put(&1, value)))
  def count, do: length(Agent.get(:some_spec_agent, &(&1)) |> Set.to_list)

  before do: Agent.start_link(fn -> HashSet.new end, name: :some_spec_agent) 
  finally do: Agent.stop(:some_spec_agent)

  let :f1, do: fn -> ChangeSpec.add(:value) end
  let :f2, do: &ChangeSpec.count/0 
  let :f3, do: fn -> :nothing end

  context "Success" do
    it do: expect(f1).to change(f2, 1)    
    it do: expect(f1).to change(f2, 0, 1)    
  end

  xcontext "Error" do
    it "change_to", do: expect(f1).to change(f2, 2)    
    it "change_to", do: expect(f3).to change(f2, 2)    
    it "change_to", do: expect(f3).to change(f2, 0)    
    
    it "change_from_to", do: expect(f1).to change(f2, 0, 2)    
    it "change_from_to", do: expect(f1).to change(f2, 1, 2)    
    it "change_from_to", do: expect(f3).to change(f2, 0, 2)    
  end
end
