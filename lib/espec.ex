defmodule ESpec do

  defmacro __using__(_arg) do
    quote do
      import unquote(__MODULE__)

      Module.register_attribute __MODULE__, :examples, accumulate: true
      Module.register_attribute __MODULE__, :context, []

      @before_compile unquote(__MODULE__)

      import ESpec.Context
      import ESpec.Example

require IEx

      def expect(do: value) do
        {ESpec.To, value}
      end

      def expect(value) do
        {ESpec.To, value}
      end



      def eq(value) do
        {:eq, value}
      end

      def be(operator, value \\ nil) do
        {:be, operator,  value}
      end

      def be_between(min, max) do
        {:be, :between, [min, max]}
      end


    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def examples, do: @examples
      def run, do: ESpec.Runner.run(@examples, __MODULE__)
    end
  end

end

defmodule ESpec.To do

  def to(rhs, {ESpec.To, lhs}) do
    case rhs do
      {:eq, value} -> ESpec.Assertion.assert(:==, lhs, value)
      {:be, :>, value} -> ESpec.Assertion.assert(:>, lhs, value)
      {:be, true, value} -> ESpec.Assertion.assert(:>, lhs, value)
      {:be, :between, [l, r]} -> ESpec.Assertion.assert(:between, lhs, l, r)
      _ -> IO.puts "No match"
    end
  end
end
