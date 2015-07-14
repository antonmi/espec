defmodule ESpec.Assertions.String.BePrintableSpec do
  use ESpec, async: true

  context "Success" do
    it do: "qwerty" |> should be_printable
    it do: <<1, 2, 3>> |> should_not be_printable
  end

  xcontext "Error" do
    it do: "qwerty" |> should_not be_printable
    it do: <<1, 2, 3>> |> should be_printable
  end
end
