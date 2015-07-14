defmodule ESpec.Assertions.List.HaveHdSpec do
  use ESpec, async: true

  subject [1,2,3]
  
  context "Success" do
    it do: should have_hd 1
    it do: should_not have_hd 2
  end

  xcontext "Error" do
    it do: should_not have_hd 1
    it do: should have_hd 2
  end
end
