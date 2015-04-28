defmodule ESpec.Assertions.String.BeValidSpec do

  use ESpec, async: true

  context "Success" do
    it do: "qwerty" |> should be_valid
    it do: <<0xffff :: 16>> |> should_not be_valid
  end

  xcontext "Error" do
    it do: "qwerty" |> should_not be_valid
    it do: <<0xffff :: 16>> |> should be_valid
  end

end