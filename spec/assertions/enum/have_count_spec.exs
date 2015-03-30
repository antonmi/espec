defmodule ESpec.Assertions.Enum.HaveCountSpec do

  use ESpec

  let :range, do: (1..3)
  
  context "Success" do
    it do: expect(range).to have_count(3)
    it do: expect(range).to_not have_count(2)
  end

  xcontext "Error" do
    it do: expect(range).to_not have_count(3)
    it do: expect(range).to have_count(2)
  end

end