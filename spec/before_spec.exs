defmodule BeforESpec do
  use ESpec, async: true

  before do: { :ok, a: "top before" }

  it do: expect(__.a).to eq("top before")
  it do: expect(__[:b]).to eq(nil)
  it do: expect(__[:c]).to eq(nil)

  describe "D1" do
    before do: { :ok, b: "D1 before" }

    it do: expect(__.a).to eq("top before")
    it do: expect(__.b).to eq("D1 before")
    it do: expect(__[:c]).to eq(nil)

    describe "D2" do
      before do: { :ok, c: "D2 before" }

      it do: expect(__.a).to eq("top before")
      it do: expect(__.b).to eq("D1 before")
      it do: expect(__.c).to eq("D2 before")
    end

    describe "Not valid" do
      before do: {:ok, [%{a: 1, b: 2}]}

      it do: expect(__.a).to eq("top before")
      it do: expect(__.b).to eq("D1 before")
    end

  end

  context "function in __" do
    before do: { :ok, a: fn(a) -> a*2 end }

    it do: expect(__.a.(5)).to eq(10)
    it do: expect(__[:b]).to eq(nil)
    it do: expect(__[:c]).to eq(nil)
  end

  context "before block does not return :ok" do
    before do: :smth
    it do: expect(__.a).to eq("top before")
  end

  context "__ is available in next befores" do
    before do: { :ok, a: 1 }
    before do: { :ok, b: __[:a] + 1 }
    it do: expect(__.b).to eq(2)
  end

  context "many before blocks" do
    before do: { :ok, a: "a" }
    before do: { :ok, a: "aa", b: "b"}
    before do: { :ok, a: "aaa", b: "bbb", c: "ccc"}

    it do: expect(__.a).to eq("aaa")
    it do: expect(__.b).to eq("bbb")
    it do: expect(__.c).to eq("ccc")
  end
end
