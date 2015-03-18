defmodule Espec.Example do

  alias Espec.Support

  defstruct description: "", function: "", context: []

  defmacro example(description, do: block) do
    function = (random_atom(description))
    quote do
      context = Enum.reverse(@context)
      @examples %Espec.Example{ description: unquote(description), function: unquote(function), context: context }
      def unquote(function)(var!(bdata)), do: unquote(block)
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

  def full_description(%Espec.Example{context: context, description: description, function: function}) do
    context_description = context
    |> Enum.filter(fn(struct) -> struct.__struct__ == Espec.Context end)
    |> Enum.map(&(&1.description))
    context_description ++ [description]
    |> Enum.join(" ")
  end

  defp random_atom(arg) do
    String.to_atom("example_#{Support.word_chars(arg)}_#{Support.random_string}")
  end


end
