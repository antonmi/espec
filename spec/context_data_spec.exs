defmodule ContextDataSpec do

  use ESpec

  before do
    { :ok, [a: 1, b: 2]}
  end

  context do
    before do
      :smth
    end

    describe do
      before do
        { :ok, c: 3 }
      end

      it "test data" do
        expect(__[:a]).to eq(1)
        expect(__[:b]).to eq(2)
        expect(__[:c]).to eq(3)
      end
    end
  end

end
