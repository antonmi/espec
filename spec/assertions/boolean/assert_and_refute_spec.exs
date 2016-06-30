defmodule ESpec.Assertions.Boolean.AssertAndRefuteSpec do
  use ESpec, async: true

  context "Success" do
    it do: assert 1
    it do: refute nil
  end

  xcontext "Errors" do
    it do: assert false
    it do: refute "a"
  end
end
