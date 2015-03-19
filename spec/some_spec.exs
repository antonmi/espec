defmodule SomESpec do
  use ESpec

  describe "d1" do
    it "some_spec_1" do
      expect(2+2).to eq(4)
    end

    describe "d1_1" do

      it "some_spec_2" do
        expect(5).to be :>, 2
      end

      describe "d1_2" do
        it "some_spec_3" do
          expect(1 == 1).to be true
        end
      end

    end

  end

  describe "d2" do
    describe "d2_1" do
      it "EXPECT" do
        (expect do: 1+1).to eq(2)
      end
    end
  end

  it "some_spec_5" do

  end
end
