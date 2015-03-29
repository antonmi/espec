defmodule ESpec.Context do
  @moduledoc """
    Defines macros 'context', 'describe', and 'example_group'.
    Defines macros for 'skip' and 'focus' example groups
  """

  @aliases ~w(describe example_group)a
  @skipped ~w(xcontext xdescribe xexample_group)a
  @focused ~w(fcontext fdescribe fexample_group)a

  @doc """
    Context has description and options.
    Available options are:
    - [skip: true] or [skip: "Reason"] - skips examples in the context;
    - [focus: true] - sets focus to run with `--focus ` option.
  """
  defstruct description: "", opts: []

  @doc "Add context with description and opts to 'example context'."
  defmacro context(description, opts, do: block) do
    quote do
      tail = @context
      head =  %ESpec.Context{ description: unquote(description), opts: unquote(opts) }
      @context [head | tail]
      unquote(block)
      @context tail
    end
  end

  @doc "context with description only"
  defmacro context(description, do: block) when is_binary(description) do
    quote do
      unquote(__MODULE__).context(unquote(description), [], do: unquote(block))
    end
  end

  @doc "context with opts only"
  defmacro context(opts, do: block) when is_list(opts) do
    quote do: unquote(__MODULE__).context("", unquote(opts), do: unquote(block))
  end

  @doc "Add empty context."
  defmacro context(do: block) do
    quote do: unquote(__MODULE__).context("", [], do: unquote(block))
  end

  @doc "Aliases for `context`."
  Enum.each @aliases, fn(func) ->
    defmacro unquote(func)(description, opts, do: block) do
      quote do: unquote(__MODULE__).context(unquote(description), unquote(opts), do: unquote(block))
    end

    defmacro unquote(func)(description_or_opts, do: block) do
      quote do: unquote(__MODULE__).context(unquote(description_or_opts), do: unquote(block))
    end

    defmacro unquote(func)(do: block) do
      quote do: unquote(__MODULE__).context(do: unquote(block))
    end
  end

  @doc "Macros for skipped contexts"
  Enum.each @skipped, fn(func) ->
    defmacro unquote(func)(description, opts, do: block) do
      reason = "`#{unquote(func)}`"
      quote do: unquote(__MODULE__).context(unquote(description), Keyword.put(unquote(opts), :skip, unquote(reason)), do: unquote(block))
    end

    defmacro unquote(func)(description, do: block) when is_binary(description) do
      reason = "`#{unquote(func)}`"
      quote do: unquote(__MODULE__).context(unquote(description), [skip: unquote(reason)], do: unquote(block))
    end

    defmacro unquote(func)(opts, do: block) when is_list(opts) do
      reason = "`#{unquote(func)}`"
      quote do: unquote(__MODULE__).context(Keyword.put(unquote(opts), :skip, unquote(reason)), do: unquote(block))
    end

    defmacro unquote(func)(do: block) do
      reason = "`#{unquote(func)}`"
      quote do: unquote(__MODULE__).context([skip: unquote(reason)], do: unquote(block))
    end
  end

  @doc "Macros for focused contexts"
  Enum.each @focused, fn(func) ->
    defmacro unquote(func)(description, opts, do: block) do
      quote do: unquote(__MODULE__).context(unquote(description), Keyword.put(unquote(opts), :focus, true), do: unquote(block))
    end

    defmacro unquote(func)(description, do: block) when is_binary(description) do
      quote do: unquote(__MODULE__).context(unquote(description), [focus: true], do: unquote(block))
    end

    defmacro unquote(func)(opts, do: block) when is_list(opts) do
      quote do: unquote(__MODULE__).context(Keyword.put(unquote(opts), :focus, true), do: unquote(block))
    end

    defmacro unquote(func)(do: block) do
      quote do: unquote(__MODULE__).context([focus: true], do: unquote(block))
    end
  end


end
