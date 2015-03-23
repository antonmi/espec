defmodule ESpec.Example do

  alias ESpec.Support

  defstruct description: "", function: "", file: nil, line: nil, context: [], success: nil, error: %ESpec.AssertionError{}

  defmacro example(description, do: block) do
    function = (random_atom(description))
    quote do
      context = Enum.reverse(@context)

      @examples %ESpec.Example{ description: unquote(description), function: unquote(function),
                                file: __ENV__.file, line: __ENV__.line, context: context }
      def unquote(function)(var!(__)), do: unquote(block)
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

  def full_description(%ESpec.Example{context: context, description: description, function: function}) do
    context_description = context
    |> Enum.filter(fn(struct) -> struct.__struct__ == ESpec.Context end)
    |> Enum.map(&(&1.description))
    context_description ++ [description]
    |> Enum.join(" ")
  end

  defp random_atom(arg) do
    String.to_atom("example_#{Support.word_chars(arg)}_#{Support.random_string}")
  end

  def success(results) do
    results |> Enum.filter(&(&1.success))
  end

  def failed(results) do
    results |> Enum.filter(&(!&1.success))
  end


end
