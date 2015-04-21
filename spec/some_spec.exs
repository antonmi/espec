defmodule SomeSpec do
  use ESpec
  let :a, do: 1
  let :b, do: a + 1

  before do: ESpec.SomeModule.calc

	context "con", async: true do
	  it "test" do
	   	b |> should eq 2
	  end 
	  it do: b |> should eq 2
	end
  # it do: b |> should eq 2
  # it do: b |> should eq 2
end
