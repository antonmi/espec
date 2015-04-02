defmodule SomeSpec do
  use ESpec

  before do: {:ok, a: 1}
  let :b, do: __.a + 1
  let! :c, do: b + 1
  before do:  {:ok, d: c + 1}

  it do: IO.inspect __.d

 
end 

