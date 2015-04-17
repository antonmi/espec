defmodule SomeSpec do
  use ESpec, async: true
  let :a, do: 1
  let :b, do: a + 1

  before do: ESpec.SomeModule.calc
  # it do: b |> should eq 2
  # it do: b |> should eq 2
  # it do: b |> should eq 2
  # it do: b |> should eq 2
end
