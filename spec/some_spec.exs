defmodule SomeSpec do
  use ESpec

  it do: :atom |> should(be_atom)
  it do: expect(:atom).to be_atom
  it do: expect(:atom) |> to(be_atom)

  context "Success" do
    subject "qwerty"
    it do: should end_with "rty"
  end
end
