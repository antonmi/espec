defmodule ESpec.Example do
  require IEx
  defstruct description: "", function: "", context: [], opts: []

  defmacro example(description, do: block) do
    function = String.to_atom(description)
    quote do
      context = Enum.reverse(@context || [])
      @examples %ESpec.Example{ description: unquote(description), function: unquote(function), context: context }
      def unquote(function)(), do: unquote(block)
    end
  end

  defmacro example(do: block) do
    quote do
      unquote(__MODULE__).example("", do: unquote(block))
    end
  end

  defmacro it(description, do: block) do
    quote do
      unquote(__MODULE__).example(unquote(description), do: unquote(block))
    end
  end

  defmacro it(do: block) do
    quote do
      unquote(__MODULE__).example("", do: unquote(block))
    end
  end

  def full_description(%ESpec.Example{context: context, description: description, function: function, opts: opts}) do
    Enum.map(context, &(&1.description)) ++ [description]
    |> Enum.join(" ")
  end


end
