defmodule ESpec.Assertions.Enum.HaveAtSpec do

  use ESpec, async: true

  let :range, do: (1..3)
  
  context "Success" do
    it do: expect(range).to have_at(2, 3)
    it do: expect(range).to_not have_at(2, 2)
  end

  xcontext "Error" do
    it do: expect(range).to_not have_at(2, 3)
    it do: expect(range).to have_at(2, 2)
  end

end
