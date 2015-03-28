defmodule ESpec.Context do
  @moduledoc """
    Defines macros 'context' and 'describe'.
  """

  @skipped ~w(xcontext xdescribe)a
  @doc "Context has description."
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

  @doc "Alias for `context/3`."
  defmacro describe(description, opts, do: block) do
    quote do: unquote(__MODULE__).context(unquote(description), unquote(opts), do: unquote(block))
  end

  @doc "Alias for `context/2`."
  defmacro describe(description_or_opts, do: block) do
    quote do: unquote(__MODULE__).context(unquote(description_or_opts), do: unquote(block))
  end

  @doc "Alias for `context/1`."
  defmacro describe(do: block) do
    quote do: unquote(__MODULE__).context(do: unquote(block))
  end

  @doc "Macros for skipped contexts"
  Enum.each @skipped, fn(func) ->
    defmacro unquote(func)(description, opts, do: block) do
      quote do: unquote(__MODULE__).context(unquote(description), Keyword.put(unquote(opts), :skip, true), do: unquote(block))
    end

    defmacro unquote(func)(description, do: block) when is_binary(description) do
      quote do: unquote(__MODULE__).context(unquote(description), [skip: true], do: unquote(block))
    end

    defmacro unquote(func)(opts, do: block) when is_list(opts) do
      quote do: unquote(__MODULE__).context(Keyword.put(unquote(opts), :skip, true), do: unquote(block))
    end

    defmacro unquote(func)(do: block) do
      quote do: unquote(__MODULE__).context([skip: true], do: unquote(block))
    end
  end


end
