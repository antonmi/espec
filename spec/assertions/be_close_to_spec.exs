defmodule ESpec.Assertions.BeCloseToSpec do

  use ESpec, async: true

  describe "ESpec.Assertions.Between" do

    context "Success" do
      it do: expect(5).to be_close_to(4, 1)
      it do: expect(5).to be_close_to(6, 1)
      it do: expect(5.5).to be_close_to(5.3, 0.21)
      it do: expect(2).to_not be_close_to(5, 1)
    end

    xcontext "Errors" do
      it do: expect(2).to be_close_to(1, 0.9)
      it do: expect(3).to_not be_close_to(3, 0)
    end

  end

end
