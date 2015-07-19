defmodule ESpec.Assertions.Boolean.BeFalseSpec do
  use ESpec, async: true

  context "Success" do
    it do: expect(false).to be_false
    it do: expect(1).to_not be_false
  end

  xcontext "Errors" do
    it do: expect(true).to be_false
    it do: expect(false).to_not be_false
  end
end
