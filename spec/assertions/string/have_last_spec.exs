defmodule ESpec.Assertions.String.HaveLastSpec do

  use ESpec, async: true

  subject "qwerty"
  
  context "Success" do
    it do: should have_last "y"
    it do: should_not have_last "r"
  end

  xcontext "Error" do
    it do: should_not have_last "y"
    it do: should have_last "w"
  end

end