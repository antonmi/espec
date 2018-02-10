defmodule ESpec.ExampleHelpers do
  @moduledoc """
  Defines macros 'example' and 'it'.
  These macros defines function with random name which will be called when example runs.
  Example structs %ESpec.Example are accumulated in @examples attribute
  """
  @aliases ~w(it specify)a
  @skipped ~w(xit xexample xspecify)a
  @focused ~w(fit fexample fspecify focus)a

  @doc """
  Adds example to @examples and defines function to wrap the spec.
  Sends `shared`' variable to the example block.
  """
  defmacro example(description, opts, do: block) do
    block =
      quote do
        unquote(block)
      end
      |> Macro.escape(unquote: true)

    quote bind_quoted: [description: description, opts: opts, block: block] do
      f_name = random_atom(description)
      context = Enum.reverse(@context)
      @examples %ESpec.Example{description: description, module: __MODULE__, function: f_name,
                               opts: opts, file: __ENV__.file, line: __ENV__.line, context: context,
                               shared: @shared}

      def unquote(f_name)(var!(shared)) do
        var!(shared)
        unquote(block)
      end
    end
  end

  @doc "Example options only"
  defmacro example(opts, do: block) when is_list(opts) do
    quote do: example("", unquote(opts), do: unquote(block))
  end

  @doc "Example with description only."
  defmacro example(description, do: block) do
    quote do: example(unquote(description), [], do: unquote(block))
  end

  @doc "Defines the simplest example."
  defmacro example(do: block) do
    quote do: example("", [], do: unquote(block))
  end

  @doc "Aliases for `example`"
  Enum.each @aliases, fn(func) ->
    defmacro unquote(func)(description, opts, do: block) do
      quote do: example(unquote(description), unquote(opts), do: unquote(block))
    end

    defmacro unquote(func)(description_or_opts, do: block) do
      quote do: example(unquote(description_or_opts), do: unquote(block))
    end

    defmacro unquote(func)(do: block) do
      quote do: example(do: unquote(block))
    end
  end

  @doc "Macros for skipped examples."
  Enum.each @skipped, fn(func) ->
    defmacro unquote(func)(description, opts, do: block) do
      reason = "`#{unquote(func)}`"
      quote do: example(unquote(description), Keyword.put(unquote(opts), :skip, unquote(reason)), do: unquote(block))
    end

    defmacro unquote(func)(description, do: block) when is_binary(description) do
      reason = "`#{unquote(func)}`"
      quote do: example(unquote(description), [skip: unquote(reason)], do: unquote(block))
    end

    defmacro unquote(func)(opts, do: block) when is_list(opts) do
      reason = "`#{unquote(func)}`"
      quote do: example(Keyword.put(unquote(opts), :skip, unquote(reason)), do: unquote(block))
    end

    defmacro unquote(func)(do: block) do
      reason = "`#{unquote(func)}`"
      quote do: example([skip: unquote(reason)], do: unquote(block))
    end
  end

  @doc "Macros for focused examples."
  Enum.each @focused, fn(func) ->
    defmacro unquote(func)(description, opts, do: block) do
      quote do: example(unquote(description), Keyword.put(unquote(opts), :focus, true), do: unquote(block))
    end

    defmacro unquote(func)(description, do: block) when is_binary(description) do
      quote do: example(unquote(description), [focus: true], do: unquote(block))
    end

    defmacro unquote(func)(opts, do: block) when is_list(opts) do
      quote do: example(Keyword.put(unquote(opts), :focus, true), do: unquote(block))
    end

    defmacro unquote(func)(do: block) do
      quote do: example([focus: true], do: unquote(block))
    end
  end

  @doc "Macros for pending exaples."
  Enum.each [:example, :pending] ++ @aliases, fn(func) ->
    defmacro unquote(func)(description) when is_binary(description) do
      quote do: example(unquote(description), [pending: unquote(description)], do: nil)
    end
  end

  @doc "Defines examples using another module."
  defmacro it_behaves_like(module, lets \\ []) when is_list lets do
    quote do
      let unquote(lets)

      Enum.each unquote(module).examples, fn(example) ->
        new_context = ESpec.ExampleHelpers.__assign_shared_lets__(example.context, @context)
        context = Enum.reverse(@context) ++ new_context
        @examples %ESpec.Example{description: example.description, module: example.module, function: example.function,
                                 opts: example.opts, file: __ENV__.file, line: __ENV__.line, context: context, shared: false}
      end
    end
  end

  @doc false
  def __assign_shared_lets__(example_context, module_context) do
    Enum.map(example_context, fn(context) ->
      case context do
        %ESpec.Let{shared: true, var: var} -> assign_shared(context, module_context, var)
        _ -> context
      end
    end)
  end

  defp assign_shared(context, module_context, var) do
    module_let = Enum.find(module_context, fn(module_let) ->
      case module_let do
        %ESpec.Let{var: ^var, shared: false} -> module_let
        _ -> false
      end
    end)
    if module_let, do: %{module_let | shared_module: context.shared_module, shared: true}, else: context
  end

  @doc "alias for include_examples"
  defmacro include_examples(module, lets \\ []) when is_list lets do
    quote do: it_behaves_like(unquote(module), unquote(lets))
  end

  def random_atom(arg) do
    String.to_atom("example_#{ESpec.Support.word_chars(arg)}_#{ESpec.Support.random_string}")
  end
end
