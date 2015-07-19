defmodule ESpec.Assertions.Boolean.BeTruthySpec do
  use ESpec, async: true

  context "Success" do
    it do: expect(1).to be_truthy
    it do: expect(nil).to_not be_truthy
  end

  xcontext "Errors" do
    it do: expect(false).to be_truthy
    it do: expect(true).to_not be_truthy
  end
end
