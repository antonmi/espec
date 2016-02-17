defmodule SomeSpec do
  use ESpec

  # before do
  #   raise "error"
  # end

  # it do
  #   expect(1).to eq(1)
  # end

  it do
     throw {:some, :term}
  end
end
