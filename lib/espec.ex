defmodule Espec do

  defmacro __using__(_arg) do
    quote do
      import unquote(__MODULE__)

      Module.register_attribute __MODULE__, :examples, accumulate: true
      @context []

      @before_compile unquote(__MODULE__)

      import Espec.Context
      import Espec.Example

      import Espec.Expect

      import Espec.Before
      import Espec.Let
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def examples, do: @examples
      def run, do: Espec.Runner.run(@examples, __MODULE__)
    end
  end






end
