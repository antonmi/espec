defmodule SomeSpec do
  use ESpec

  subject(1+1)
  it do: should eq(2)

  context "with block" do
    subject do: 2+2
    it do: should eq(4)
    it do: true |> should be true
  end

  it do: 2+2 |> should eq 4
end 