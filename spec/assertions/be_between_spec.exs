defmodule ESpec.Assertions.BetweenSpec do

  use ESpec

  describe "ESpec.Assertions.Between" do

    context "Success" do
      it do: expect(1+1).to be_between(1, 3)
      it do: expect(1+1).to_not be_between(3, 5)
    end

    context "Errors" do
      it do: expect(1+1).to be_between(3, 5)
      it do: expect(1+1).to_not be_between(1,3)
    end

  end

end
