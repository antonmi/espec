defmodule Espec.Before do

  alias Espec.Support

  defstruct function: "", opts: []

  defmacro before(do: block) do
    function = random_atom
    quote do
      tail = @context
      head =  %Espec.Before{function: unquote(function)}
      def unquote(function)(), do: unquote(block)
      @context [head | tail]
    end
  end

  def random_atom, do: String.to_atom("before_#{Support.random_string}")

end
