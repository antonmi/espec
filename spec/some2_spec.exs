defmodule Some2Spec do
  use ESpec

  describe "expectation with block" do
    it "one line" do
      (expect do: 1+1).to eq(2)
    end

    it "block" do
      (expect do
        2+2
      end).to eq(4)
    end
  end

  it do: expect(25).to be_between(10, 100)


end
