defmodule ESpec.Assertions.List.HaveFirstSpec do
  use ESpec, async: true

  subject [1,2,3]
  
  context "Success" do
    it do: should have_first 1
    it do: should_not have_first 2
  end

  xcontext "Error" do
    it do: should_not have_first 1
    it do: should have_first 2
  end
end
