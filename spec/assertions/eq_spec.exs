defmodule ESpec.Assertions.EqSpec do

  use ESpec

  describe "ESpec.Assertions.Eq" do

    context "Success" do
      it do: expect(1+1).to eq(2)
      it do: expect(1+1).to_not eq(3)
    end

    context "Errors" do
      it do: expect(1+1).to eq(3)
      it do: expect(1+1).to_not eq(2)
    end

  end

end
