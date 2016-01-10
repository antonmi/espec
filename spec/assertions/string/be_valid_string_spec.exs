defmodule ESpec.Assertions.String.BeValidSpec do
  use ESpec, async: true

  context "Success" do
    it do: "qwerty" |> should(be_valid_string)
    it do: <<0xffff :: 16>> |> should_not(be_valid_string)
  end

  xcontext "Error" do
    it do: "qwerty" |> should_not(be_valid_string)
    it do: <<0xffff :: 16>> |> should(be_valid_string)
  end
end
