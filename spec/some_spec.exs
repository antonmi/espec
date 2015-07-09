defmodule SomeSpec do
  use ESpec
  
  it do: expect(2).to be_close_to(3, 1)

end
