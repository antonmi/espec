defmodule ESpec.Subject do

  defstruct value: nil

  defmacro __using__(_arg) do
    quote do

    end
  end

  defmacro subject(do: block) do
    quote do
      tail = @context
      head =  %ESpec.Subject{value: unquote(block)}
      @context [head | tail]
    end
  end

  def random_atom, do: String.to_atom("before_#{Support.random_string}")



end
