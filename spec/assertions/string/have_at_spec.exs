defmodule ESpec.Assertions.String.HaveAt do
  use ESpec, async: true

  subject "qwerty"
  
  context "Success" do
    it do: should have_at(2, "e")
    it do: should_not have_at(2, "q")
  end

  xcontext "Error" do
    it do: should_not have_at(2, "e")
    it do: should have_at(2, "q")
  end
end
