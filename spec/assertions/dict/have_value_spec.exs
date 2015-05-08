defmodule ESpec.Assertions.Dict.HaveValueSpec do

  use ESpec, async: true

  subject %{a: 1, b: 2}
  
  context "Success" do
    it do: should have_value 1
    it do: should_not have_value 3
  end

  xcontext "Error" do
    it do: should_not have_value 1
    it do: should have_value 3
  end

end