defmodule ESpec.Finally do
  @moduledoc """
  Defines `finally` macro.
  The block is evaluated after the example.
  `shared` is available.
  Define the `finally` before example!.
  """

  @doc "Struct has random fuction name."
  defstruct module: nil, function: nil

  @doc """
  Adds %ESpec.Finally sutructs to the context and
  defines random function with random name which will be called when example is run.
  """
  defmacro finally(do: block) do
    function = random_finally_name
    quote do
      tail = @context
      head =  %ESpec.Finally{module: __MODULE__, function: unquote(function)}
      def unquote(function)(var!(shared)) do
        var!(shared)
        unquote(block)
      end
      @context [head | tail]
    end
  end

  defp random_finally_name, do: String.to_atom("finally_#{ESpec.Support.random_string}")
end
