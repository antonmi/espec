defmodule ESpec.Context do
  @moduledoc """
    Defines macros 'context' and 'describe'.
  """

  @doc """
    Context has description.
  """
  defstruct description: ""

  @doc """
    Add context with description to 'example context'.
  """
  defmacro context(description, body) do
    quote do
      tail = @context
      head =  %ESpec.Context{ description: unquote(description) }
      @context [head | tail]
      unquote(body)
      @context tail
    end
  end

  @doc """
    Alias for `context/2`.
  """
  defmacro describe(description, body) do
    quote do
      unquote(__MODULE__).context(unquote(description), unquote(body))
    end
  end

  @doc """
    Add context without description.
  """
  defmacro context(do: block) do
    quote do
      unquote(__MODULE__).context("", do: unquote(block))
    end
  end

  @doc """
    Alias for `context/1`.
  """
  defmacro describe(do: block) do
    quote do
      unquote(__MODULE__).context("", unquote(block))
    end
  end

end
