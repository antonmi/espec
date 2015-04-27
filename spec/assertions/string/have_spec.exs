defmodule ESpec.Assertions.String.Have do

  use ESpec, async: true

  subject "qwerty"
  
  context "Success" do
    it do: should have("we")
    it do: should_not have("z")
  end

  xcontext "Error" do
    it do: should_not have("qwe")
    it do: should have("zx")
  end

end