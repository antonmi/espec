defmodule SomeSpec do
  use ESpec
  
  it do: expect(2).to be_close_to(3, 1)

  describe "describe" do
    it do: true |> should be true
  end

  context "pending" do
    xit do: "some example"
  end

end
