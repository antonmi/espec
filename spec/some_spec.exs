defmodule SomeSpec do
  use ESpec
  
  it do: expect(2).to be_close_to(3, 1)

  describe "describe" do
    xit do: SomeModule.asdfsad |> should be false
  end

  context "pending" do
    it do: raise "some example"
  end
end
