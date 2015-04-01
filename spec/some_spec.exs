defmodule SomeSpec do
  use ESpec

  it "Top level example" do

  end

  context "Context 1" do

    describe "Describe 1" do
    
      it  "Inner example" do
        2 |> should eq 2
      end

      subject do: 5

      it do: should eq 4
      it "Pending"
    end
  end
 
end 
