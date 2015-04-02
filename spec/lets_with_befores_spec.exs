defmodule LetsWithBeforesSpec do
  use ESpec

  before do: {:ok, a: 1}
	it do: __.a |> should eq(1)

  let :b, do: __.a + 1
	it do: b |> should eq(2)

  let! :c, do: b + 1
	it do: c |> should eq(3)

  before do:  {:ok, d: c + 1}
  it do: __.d |> should eq(4)

end 
