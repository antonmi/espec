defmodule SomeSpec do
  use ESpec
  let :a, do: 1
  let :b, do: a + 1

  before do: a + b
  it do: b |> should eq 2
end
