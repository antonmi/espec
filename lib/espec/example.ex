defmodule ESpec.Example do
  @moduledoc """
  Defines macros 'example' and 'it'.
  These macros defines function with random name which will be called when example runs.
  Example structs %ESpec.Example are accumulated in @examples attribute
  """
  @aliases ~w(it specify)a
  @skipped ~w(xit xexample xspecify)a
  @focused ~w(fit fexample fspecify focus)a

  @doc """
  Expampe struct.
  description - the description of example,
  module - spec module,
  function - random function name,
  opts - options,
  file - spec file path,
  line - the line where example is defined,
  context - example context. Accumulator for 'contexts' and 'lets',
  status - example status (:new, :success, :failure, :pending),
  result - the value returned by example block or the pending message
  error - store an error
  """
  defstruct description: "", module: nil, function: nil, opts: [],
            file: nil, line: nil, context: [],
            status: :new, result: nil, error: %ESpec.AssertionError{}

  @doc """
  Adds example to @examples and defines function to wrap the spec.
  Sends 'double-underscore `__`' variable to the example block.
  """
  defmacro example(description, opts, do: block) do
    function = (random_atom(description))
    quote do
      context = Enum.reverse(@context)

      @examples %ESpec.Example{ description: unquote(description), module: __MODULE__, function: unquote(function),
                                opts: unquote(opts), file: __ENV__.file, line: __ENV__.line, context: context }
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

  @doc "Aliases for `example`"
  Enum.each @aliases, fn(func) ->
    defmacro unquote(func)(description, opts, do: block) do
      quote do: unquote(__MODULE__).example(unquote(description), unquote(opts), do: unquote(block))
    end

    defmacro unquote(func)(description_or_opts, do: block) do
      quote do: unquote(__MODULE__).example(unquote(description_or_opts), do: unquote(block))
    end

    defmacro unquote(func)(do: block) do
      quote do: unquote(__MODULE__).example(do: unquote(block))
    end
  end

  @doc "Macros for skipped examples"
  Enum.each @skipped, fn(func) ->
    defmacro unquote(func)(description, opts, do: block) do
      reason = "`#{unquote(func)}`"
      quote do: unquote(__MODULE__).example(unquote(description), Keyword.put(unquote(opts), :skip, unquote(reason)), do: unquote(block))
    end

    defmacro unquote(func)(description, do: block) when is_binary(description) do
      reason = "`#{unquote(func)}`"
      quote do: unquote(__MODULE__).example(unquote(description), [skip: unquote(reason)], do: unquote(block))
    end

    defmacro unquote(func)(opts, do: block) when is_list(opts) do
      reason = "`#{unquote(func)}`"
      quote do: unquote(__MODULE__).example(Keyword.put(unquote(opts), :skip, unquote(reason)), do: unquote(block))
    end

    defmacro unquote(func)(do: block) do
      reason = "`#{unquote(func)}`"
      quote do: unquote(__MODULE__).example([skip: unquote(reason)], do: unquote(block))
    end
  end

  @doc "Macros for focused examples"
  Enum.each @focused, fn(func) ->
    defmacro unquote(func)(description, opts, do: block) do
      quote do: unquote(__MODULE__).example(unquote(description), Keyword.put(unquote(opts), :focus, true), do: unquote(block))
    end

    defmacro unquote(func)(description, do: block) when is_binary(description) do
      quote do: unquote(__MODULE__).example(unquote(description), [focus: true], do: unquote(block))
    end

    defmacro unquote(func)(opts, do: block) when is_list(opts) do
      quote do: unquote(__MODULE__).example(Keyword.put(unquote(opts), :focus, true), do: unquote(block))
    end

    defmacro unquote(func)(do: block) do
      quote do: unquote(__MODULE__).example([focus: true], do: unquote(block))
    end
  end

  @doc "Macros for pending exaples"
  Enum.each [:example, :pending] ++ @aliases, fn(func) ->
    defmacro unquote(func)(description) when is_binary(description) do
      quote do: unquote(__MODULE__).example(unquote(description), [pending: unquote(description)], do: nil)
    end
  end
  

  @doc "Description with contexts."
  def context_descriptions(%ESpec.Example{context: context, description: _description, function: _function}) do
    context
    |> Enum.filter(fn(struct) -> struct.__struct__ == ESpec.Context end)
    |> Enum.map(&(&1.description))
  end

  @doc "Filters success examples"
  def success(results) do
    results |> Enum.filter(&(&1.status == :success))
  end

  @doc "Filters failed examples"
  def failure(results) do
    results |> Enum.filter(&(&1.status === :failure))
  end

  @doc "Filters pending examples"
  def pendings(results) do
    results |> Enum.filter(&(&1.status === :pending))
  end

  def skip_message(example, contexts) do
    skipper = Enum.find(contexts, &(&1.opts[:skip])) || example
    if skipper.opts[:skip] === true do
      "Temporarily skipped without a reason."
    else
      "Temporarily skipped with: #{skipper.opts[:skip]}."
    end
  end

  def pending_message(example, _contexts) do
    if example.opts[:pending] === true do
      "Pending example."
    else
      "Pending with message: #{example.opts[:pending]}."
    end
  end

  defp random_atom(arg) do
    String.to_atom("example_#{ESpec.Support.word_chars(arg)}_#{ESpec.Support.random_string}")
  end

end
