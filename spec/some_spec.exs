defmodule SomeSpec do

  use ESpec

  it do: expect(2).to be :>, 1
end
