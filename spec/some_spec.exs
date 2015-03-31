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
  it do: (1..3) |> should have 2

	it do: expect("abc").to match(~r/b/)
  it do: 5 |> should be_between(4,6)

  example do: expect([1,2,3]).to have_max(3)
  
  it "Test with description" do
    4.2 |> should_not be_close_to(4, 0.1)
  end

  context do

  	 subject(1+1)
  it do: is_expected.to eq(2)
  it do: should eq 2

  context "with block" do
    subject do: 2+2
    it do: is_expected.to_not eq(2)
    it do: should_not eq 2
  end
	end
end 