defmodule ESpec.Assertions.Enum.HaveSpec do

  use ESpec, async: true

  let :range, do: (1..3)
  
  context "Success" do
    it do: expect(range).to have(2)
    it do: expect(range).to_not have(4)
  end

  xcontext "Error" do
    it do: expect(range).to_not have(2)
    it do: expect(range).to have(4)
  end

end