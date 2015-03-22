defmodule ItIsExpectedSpec do

  use ESpec

  subject do: 1+1

  it do: is_expected.to eq(2)



end
