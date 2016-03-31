defmodule SomeSpec do
  use ESpec

  let :a, do: 1
  subject 2

  it do
    a |> should(eq 1)
    should(a, eq 1)
    a |> should(eq([1] |> List.first))
    # should eq(2)
  end


end
