defmodule ESpec.Assertions.List.HaveLastSpec do

  use ESpec, async: true

  subject [1,2,3]
  
  context "Success" do
    it do: should have_last 3
    it do: should_not have_last 2
  end

  xcontext "Error" do
    it do: should_not have_last 3
    it do: should have_last 2
  end

end