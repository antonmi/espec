defmodule LetSpec do
  use ESpec, async: true

  describe "let!" do
    let!(:f) do
      fn(x) -> x*2 end
    end

    it do: expect(f.(2)).to eq(4)

    context "redefine" do
      let! :f, do: 5
      it do: expect(f).to eq(5)
    end

    context "use __" do
      before do: {:ok, a: 1}
      let! :a, do: __[:a] + 1
      it do: expect(a).to eq(2)
    end
  end

  describe "let" do
    let(:f) do
      fn(x) -> x*2 end
    end

    it do: expect(f.(2)).to eq(4)

    context "redefine" do
      let :f, do: 5
      it do: expect(f).to eq(5)
    end

    context "use __" do
      before do: {:ok, a: 1}
      let :a, do: __[:a] + 1
      it do: expect(a).to eq(2)
    end

    context "let runs only when called" do
      let :b, do: IO.puts("You will not see it")
      it do: expect(1).to eq(1)
    end
  end

  describe "let use let" do
    let :a, do: 1
    let :b, do: a + 1

    it do: b |> should eq 2
  end
end
