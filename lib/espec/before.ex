defmodule ESpec.Before do
  @moduledoc """
  Defines 'before' macro.
  If before block returns {:ok, key: value},
  the {key, value} is added to an 'exapmle dict'.
  The dict can be accessed in another `before`, in `let`,
  and in example by `__` (`__[:key]`).
  """

  @doc "Struct has random fuction name."
  defstruct function: ""

  @doc """
  Adds %ESpec.Before sutructs to the context and
  defines random function with random name which will be called when example is run.
  """
  defmacro before(do: block) do
    function = random_before_name
    quote do
      tail = @context
      head =  %ESpec.Before{function: unquote(function)}
      def unquote(function)(), do: unquote(block)
      @context [head | tail]
    end
  end

  defp random_before_name, do: String.to_atom("before_#{ESpec.Support.random_string}")

end
