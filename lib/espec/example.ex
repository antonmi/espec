defmodule ESpec.Example do
  @moduledoc """
  Defines macros 'example' and 'it'.
  These macros defines function with random name which will be called when example runs.
  Example structs %ESpec.Example are accumulated in @examples attribute
  """

  @doc """
  Expampe struct.
  description - the description of example,
  function - random function name,
  opts - options,
  file - spec file path,
  line - the line where example is defined,
  context - example context. Accumulator for 'contexts' and 'lets',
  success - store example result,
  result - the value returned by example block
  error - store an error
  """
  defstruct description: "", function: "", opts: [],
            file: nil, line: nil, context: [],
            success: nil, result: nil, error: %ESpec.AssertionError{}

  @doc """
  Adds example to @examples and defines function to wrap the spec.
  Sends 'double underscore `__`' variable to the example block.
  """
  defmacro example(description, opts, do: block) do
    function = (random_atom(description))
    quote do
      context = Enum.reverse(@context)

      @examples %ESpec.Example{ description: unquote(description), function: unquote(function), opts: unquote(opts),
                                file: __ENV__.file, line: __ENV__.line, context: context }
      def unquote(function)(var!(__)), do: unquote(block)
    end
  end

  @doc "Example with description only"
  defmacro example(description, do: block) when is_binary(description) do
    quote do: unquote(__MODULE__).example(unquote(description), [], do: unquote(block))
  end

  @doc "Example options only"
  defmacro example(opts, do: block) when is_list(opts) do
    quote do: unquote(__MODULE__).example("", unquote(opts), do: unquote(block))
  end

  @doc "Defines the simplest example"
  defmacro example(do: block) do
    quote do: unquote(__MODULE__).example("", [], do: unquote(block))
  end

  @doc "Alias for `example/3`"
  defmacro it(description, opts, do: block) do
    quote do: unquote(__MODULE__).example(unquote(description), unquote(opts), do: unquote(block))
  end

  @doc "Alias for `example/2`"
  defmacro it(description_or_opts, do: block) do
    quote do: unquote(__MODULE__).example(unquote(description_or_opts), do: unquote(block))
  end

  @doc "Alias for `example/1`"
  defmacro it(do: block) do
    quote do: unquote(__MODULE__).example(do: unquote(block))
  end

  @doc "Description with contexts."
  def full_description(%ESpec.Example{context: context, description: description, function: function}) do
    context_description = context
    |> Enum.filter(fn(struct) -> struct.__struct__ == ESpec.Context end)
    |> Enum.map(&(&1.description))
    context_description ++ [description]
    |> Enum.join(" ")
  end

  @doc "Filters success examples"
  def success(results) do
    results |> Enum.filter(&(&1.success))
  end

  @doc "Filters failed examples"
  def failed(results) do
    results |> Enum.filter(&(!&1.success))
  end

  defp random_atom(arg) do
    String.to_atom("example_#{ESpec.Support.word_chars(arg)}_#{ESpec.Support.random_string}")
  end

end
