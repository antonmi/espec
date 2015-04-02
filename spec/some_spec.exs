defmodule SomeSpec do
  use ESpec

  it "Top level example" do

  end

  context "Context 1" do

    describe "Describe 1" do
    
      it  "Inner example" do
        2 |> should eq 2
      end

      subject do: "a"

      it do: should match "a"
      it "Pending with"
    end
  end
 
end 
