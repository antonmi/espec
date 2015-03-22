defmodule LetSpec do
  use ESpec

  let :top, do: 10

  it do: expect(top).to eq(10)

  context "Inner" do
    let :inner do
      55
    end

    let :top, do: 100500 #don't change the top

    it "check top", do: expect(top).to eq(10)

    it "checks inner", do: expect(inner).to eq(55)
  end

end
