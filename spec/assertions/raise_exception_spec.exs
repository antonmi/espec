defmodule ESpec.Assertions.RaiseExceptionSpec do

  use ESpec

  describe "ESpec.Assertions.RaiseException" do

    let :func1, do: fn -> 1+"test" end
    let :func2, do: fn -> 1+1 end
    let :func3, do: fn -> List.first(:a) end

    context "Success" do
      it do: expect(func1).to raise_exception
      it do: expect(func1).to raise_exception(ArithmeticError)
      it do: expect(func1).to raise_exception(ArithmeticError, "bad argument in arithmetic expression")

      it do: expect(func2).to_not raise_exception
      it do: expect(func2).to_not raise_exception(ArithmeticError, "bad argument in arithmetic expression")
      it do: expect(func2).to_not raise_exception(ArithmeticError)

      it do: expect(func3).to_not raise_exception(ArithmeticError)
      it do: expect(func3).to_not raise_exception(FunctionClauseError, "no such message")
    end

    xcontext "Errors" do
      it do: expect(func2).to raise_exception
      it do: expect(func2).to raise_exception(ArithmeticError)
      it do: expect(func2).to raise_exception(ArithmeticError, "bad argument in arithmetic expression")

      it do: expect(func1).to_not raise_exception
      it do: expect(func1).to_not raise_exception(ArithmeticError)
      it do: expect(func1).to_not raise_exception(ArithmeticError, "bad argument in arithmetic expression")

      it do: expect(func3).to_not raise_exception(FunctionClauseError)
      it do: expect(func3).to_not raise_exception(FunctionClauseError, "no function clause matching in List.first/1")
    end

  end

end
