defmodule ESpec.Assertions.String.EndWithSpec do

  use ESpec, async: true

  subject "qwerty"
  
  context "Success" do
    it do: should end_with "rty"
    it do: should_not end_with "ert"
  end

  xcontext "Error" do
    it do: should_not end_with "rty"
    it do: should end_with "ert"
  end

  context "Short string" do
    subject "q"
    context "Success" do
      it do: should end_with "q"
      it do: should_not end_with "ert"
    end
    xcontext "Error" do
      it do: should_not end_with "q"
      it do: should end_with "e"
    end    
  end

end