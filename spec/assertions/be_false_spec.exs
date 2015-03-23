defmodule ESpec.Assertions.BeFalseSpec do

  use ESpec

  describe "ESpec.Assertions.False" do

    context "Success" do
      it do: expect(1+1 == 1).to be_false
      it do: expect(false).to be_false
      it do: expect(1+1 == 1).to_not be_true
    end

    context "Errors" do
      it do: expect(1+1 == 2).to be_false
      it do: expect(false).to_not be_false
    end

  end

end
