defmodule BeforESpec do

  use ESpec

  before do
    { :ok, a: "top before" }
  end

  it do: expect(__[:a]).to eq("top before")
  it do: expect(__[:b]).to eq(nil)
  it do: expect(__[:c]).to eq(nil)

  describe "D1" do

    before do
      { :ok, b: "D1 before" }
    end

    it do: expect(__[:a]).to eq("top before")
    it do: expect(__[:b]).to eq("D1 before")
    it do: expect(__[:c]).to eq(nil)

    describe "D2" do
      before do
        { :ok, c: "D2 before" }
      end

      it do: expect(__[:a]).to eq("top before")
      it do: expect(__[:b]).to eq("D1 before")
      it do: expect(__[:c]).to eq("D2 before")
    end

  end

  context "function in double_underscore" do
    before do
      { :ok, a: fn(a) -> a*2 end }
    end

    it do: expect(__[:a].(5)).to eq(10)
    it do: expect(__[:b]).to eq(nil)
    it do: expect(__[:c]).to eq(nil)
  
  end


end
