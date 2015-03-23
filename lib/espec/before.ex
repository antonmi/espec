defmodule ESpec.Before do

  defstruct function: "", opts: []

  defmacro before(do: block) do
    function = random_before_name
    quote do
      tail = @context
      head =  %ESpec.Before{function: unquote(function)}
      def unquote(function)(), do: unquote(block)
      @context [head | tail]
    end
  end

  def random_before_name, do: String.to_atom("before_#{ESpec.Support.random_string}")

end
