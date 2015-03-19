defmodule ESpec.Let do

  defmacro let(var, do: block) do
    quote do
      defp unquote(var)(), do: unquote(block)
    end
  end

end
