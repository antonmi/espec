defmodule ESpec.Assertions.String.HaveFirstSpec do

  use ESpec, async: true

  subject "qwerty"
  
  context "Success" do
    it do: should have_first "q"
    it do: should_not have_first "w"
  end

  xcontext "Error" do
    it do: should_not have_first "q"
    it do: should have_first "w"
  end

end