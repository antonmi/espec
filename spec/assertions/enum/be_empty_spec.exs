defmodule ESpec.Assertions.Enum.BeEmptySpec do

  use ESpec

  context "Success" do
    it do: expect([]).to be_empty
    it do: expect([1,2,3]).to_not be_empty
  end

  xcontext "Error" do
    it do: expect([]).to_not be_empty
    it do: expect([1,2,3]).to be_empty
  end

end