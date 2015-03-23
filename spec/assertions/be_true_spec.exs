defmodule ESpec.Assertions.BeTrueSpec do

  use ESpec

  describe "ESpec.Assertions.True" do

    context "Success" do
      it do: expect(1+1 == 2).to be_true
      it do: expect(true).to be_true
      it do: expect(1+1 == 1).to_not be_true
    end

    context "Errors" do
      it do: expect(1+1 == 1).to be_true
      it do: expect(true).to_not be_true
    end

  end

end
