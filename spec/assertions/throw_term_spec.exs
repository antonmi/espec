defmodule ESpec.Assertions.ThrowTermSpec do

  use ESpec

  describe "ESpec.Assertions.RaiseException" do

    let :func1, do: fn -> throw(:some_term) end
    let :func2, do: fn -> 1+1 end


    context "Success" do
      it do: expect(func1).to throw_term
      it do: expect(func1).to throw_term(:some_term)
  
      it do: expect(func1).not_to throw_term(:another_term)
    end

    xcontext "Errors" do
      it do: expect(func2).to throw_term
      it do: expect(func1).to_not throw_term

      it do: expect(func2).to throw_term(:some_term)

      it do: expect(func1).to throw_term(:another_term)
      it do: expect(func1).not_to throw_term(:some_term)
    end

  end

end
