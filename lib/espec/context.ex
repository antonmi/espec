defmodule ESpec.Context do

  defstruct description: "", opts: []

  defmacro context(description, body) do
    quote do
      tail = @context
      head =  %ESpec.Context{ description: unquote(description) }
      @context if tail, do: [head | tail], else: [head]
      unquote(body)
      @context tail
    end
  end

  defmacro describe(description, body) do
    quote do
      unquote(__MODULE__).context(unquote(description), unquote(body))
    end
  end

end
