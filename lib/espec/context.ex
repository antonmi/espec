defmodule Espec.Context do

  defstruct description: ""

  defmacro context(description, body) do
    quote do
      tail = @context
      head =  %Espec.Context{ description: unquote(description) }
      @context [head | tail]
      unquote(body)
      @context tail
    end
  end

  defmacro describe(description, body) do
    quote do
      unquote(__MODULE__).context(unquote(description), unquote(body))
    end
  end

  defmacro context(do: block) do
    quote do
      unquote(__MODULE__).context("", do: unquote(block))
    end
  end

  defmacro describe(do: block) do
    quote do
      unquote(__MODULE__).context("", unquote(block))
    end
  end

end
