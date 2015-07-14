defmodule ESpec.Assertions.String.HaveCountSpec do
  use ESpec, async: true

  subject "qwerty"
  
  context "Success" do
    it do: should have_count(6)
    it do: should_not have_count(3)
  end

  context "aliases" do
    it do: should have_size(6)
    it do: should have_length(6)
  end

  xcontext "Error" do
    it do: should_not have_count(6)
    it do: should have_count(3)
  end
end
