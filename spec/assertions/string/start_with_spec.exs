defmodule ESpec.Assertions.String.StartWithSpec do

  use ESpec, async: true

  subject "qwerty"
  
  context "Success" do
    it do: should start_with "qwe"
    it do: should_not start_with "ert"
  end

  xcontext "Error" do
    it do: should_not start_with "qwe"
    it do: should start_with "ert"
  end

  context "Short string" do
    subject "q"
    context "Success" do
      it do: should start_with "q"
      it do: should_not start_with "ert"
    end
    xcontext "Error" do
      it do: should_not start_with "qw"
      it do: should start_with "e"
    end    
  end

end