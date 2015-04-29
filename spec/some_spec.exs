defmodule SomeSpec do
  use ESpec
  
  before do
  	allow(ESpec.SomeModule).to accept(:fun, fn(a) -> a end)
  end

  it do
  	ESpec.SomeModule.fun(1) |> should eq 1
  end

end
