defmodule ESpec.Assertions.Enum.HaveSpec do
  use ESpec, async: true

  let :range, do: (1..3)
  let :list, do: [{}]
  
  context "Success" do
    it do: expect(range).to have(2)
    it do: expect(range).to_not have(4)
    it do: expect(list).to have({})
  end

  xcontext "Error" do
    it do: expect(range).to_not have(2)
    it do: expect(range).to have(4)
    it do: expect(list).to_not have({})
  end
end
