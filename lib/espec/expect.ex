defmodule ESpec.Expect do
  @moduledoc """
  Defines helper functions for modules which use ESpec.
  These fucntions wrap arguments for ESpec.ExpectTo module.
  """

  @doc false
  defmacro __using__(_arg) do
    quote do
      @doc "The same as `expect(subject)`"
      def is_expected do
        {ESpec.ExpectTo, apply(__MODULE__, :subject, [])}
      end
    end
  end

  @doc "Wrapper for `ESpec.ExpectTo`. Passes the value returned by the block."
  def expect(do: value), do: {ESpec.ExpectTo, value}

  @doc "Wrapper for `ESpec.ExpectTo`."
  def expect(value), do: {ESpec.ExpectTo, value}

end
