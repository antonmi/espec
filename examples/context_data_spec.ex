defmodule ContextDataSpec do

  use Espec

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
        expect(assigns[:a]).to eq(1)
        expect(assigns[:b]).to eq(2)
        expect(assigns[:c]).to eq(3)
      end
    end
  end

end


ContextDataSpec.run
