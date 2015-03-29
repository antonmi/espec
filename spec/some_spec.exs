defmodule SomeSpec do
  use ESpec

  subject(1+1)
  it do: is_expected.to eq(2)

  context "with block" do
    subject do: 2+2
    it do: is_expected.to eq(4)
    it do: expect(true).to be true
  end
end 