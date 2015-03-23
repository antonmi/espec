defmodule ESpec.Assertions.BeNilSpec do

  use ESpec

  describe "ESpec.Assertions.Nil" do

    context "Success" do
      it do: expect(nil).to be_nil
      it do: expect(1).to_not be_nil
    end

    context "Errors" do
      it do: expect(1).to be_nil
      it do: expect(nil).to_not be_nil
    end

  end

end
