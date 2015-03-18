defmodule LetSpec do
  use Espec

  let :top, do: 10

  it do: expect(top).to eq(10)

  context "Inner" do
    let :inner do
      55
    end

    it "check top", do: expect(top).to eq(10)
    it "checks inner", do: expect(top).to eq(10)
  end

end


LetSpec.run
