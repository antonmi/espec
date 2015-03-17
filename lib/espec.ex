defmodule ESpec do

  defmacro __using__(_arg) do
    quote do
      import unquote(__MODULE__)

      Module.register_attribute __MODULE__, :examples, accumulate: true
      @context []

      @before_compile unquote(__MODULE__)

      import ESpec.Context
      import ESpec.Example

      import ESpec.Expect
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def examples, do: @examples
      def run, do: ESpec.Runner.run(@examples, __MODULE__)
    end
  end

  defmacro let(var, do: block) do
    quote do
      defp unquote(var)(), do: unquote(block)
    end
  end


end
