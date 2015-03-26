defmodule LetSpec do
  use ESpec

  let :top, do: 10

  it do: expect(top).to eq(10)

  context "Inner" do
    let :inner do
      55
    end

    let :top, do: 100500

    it "check top", do: expect(top).to eq(100500)

    it "checks inner", do: expect(inner).to eq(55)

    context "More inner" do
      let :top, do: 500100
      it do: expect(top).to eq(500100)
    end
  end

  context "" do
    before do: IO.puts("Before") 

    let :fff do
      a = 1+1
      b = 2+2
      IO.puts("Let")
      a + b
    end

    it do
      IO.puts("It")
     expect(fff).to eq(6)
   end
  end

end
