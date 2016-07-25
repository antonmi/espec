defmodule SomeSpec do
  use ESpec, async: true, aaa: :bbb

  before do
    {:ok, %{a: 1, b: 2}}
  end

  it do
    expect(shared[:a]).to eq(1)
    expect(shared[:b]).to eq(2)
    expect(shared[:answer]).to eq(42)
  end
end
