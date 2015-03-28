defmodule ESpec.Assertions.BeSpec do

  use ESpec

  describe "ESpec.Assertions.Be" do

    # (> < >= <= == != === !== =~)

    context "Success" do
      it do: expect(2).to be :>, 1
      it do: expect(2).to_not be :>, 3

      it do: expect(1).to be :!=, 2
      it do: expect(1).to_not be :!=, 1

      it do: expect(1).to be :<=, 1
      it do: expect("abcd").to be :=~, ~r/c(d)/
    end

    xcontext "Errors" do
      it do: expect(2).to be :>, 3
      it do: expect(1).to_not be :==, 1.0
    end

  end

end
