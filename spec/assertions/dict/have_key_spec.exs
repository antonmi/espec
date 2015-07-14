defmodule ESpec.Assertions.Dict.HaveKeySpec do
  use ESpec, async: true

  subject %{a: 1, b: 2}
  
  context "Success" do
    it do: should have_key :a
    it do: should_not have_key :c
  end

  xcontext "Error" do
    it do: should_not have_key :a
    it do: should have_key :c
  end
end
