defmodule ESpec.Assertions.List.HaveTlSpec do

  use ESpec

  subject [1,2,3]
  
  context "Success" do
    it do: should have_tl [2,3]
    it do: should_not have_tl [1,2]
  end

  xcontext "Error" do
    it do: should_not have_tl [2,3]
    it do: should have_tl [1,2]
  end

end