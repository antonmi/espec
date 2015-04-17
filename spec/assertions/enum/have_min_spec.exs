defmodule ESpec.Assertions.Enum.HaveMinSpec do

  use ESpec, async: true

  let :range, do: (1..3)
  
  context "Success" do
    it do: expect(range).to have_min(1)
    it do: expect(range).to_not have_min(2)
  end

  xcontext "Error" do
    it do: expect(range).to_not have_min(1)
    it do: expect(range).to have_min(2)
  end

end