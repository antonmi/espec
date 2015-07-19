defmodule ESpec.Assertions.Boolean.BeFalsySpec do
  use ESpec, async: true

  context "Success" do
    it do: expect(nil).to be_falsy
    it do: expect(1).to_not be_falsy
  end

  xcontext "Errors" do
    it do: expect(true).to be_falsy
    it do: expect(false).to_not be_falsy
  end
end
