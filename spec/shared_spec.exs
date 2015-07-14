defmodule SharedSpec do
  use ESpec, shared: true#, async: true

  before do: {:ok, c: __.b + 1}

  let! :c, do: __.c

  context "SharedSpec context" do
    let :d, do: __.c + 1

    it do: expect(__.a).to eq(1)
    it do: expect(__.b).to eq(2)
    it do: expect(c).to eq(3)
    it do: expect(d).to eq(4)
  end


  describe "let use let" do
    let :a, do: __.a
    let :b, do: a + 1

    it do: b |> should eq 2
  end
end

defmodule UseSharedSpecSpec do
  use ESpec
  
  before do: {:ok, a: 1}

  context "SomeSpec context" do
    before do: {:ok, b: 2}

    it_behaves_like(SharedSpec)
  end
end 
