defmodule ESpec.Assertions.Boolean.BeTrueSpec do
  use ESpec, async: true

  context "Success" do
    it do: expect(true).to be_true
    it do: expect(1).to_not be_true
  end

  xcontext "Errors" do
    it do: expect(false).to be_true
    it do: expect(true).to_not be_true
  end
end
