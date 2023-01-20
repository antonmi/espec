defmodule TestModules.Docs.DocExample do
  defmodule Mod1 do
    @doc """
      iex> 1 + 1
      2

      iex> 2 + 2
      5
    """
    def f, do: :f
  end

  defmodule Mod2 do
    @doc """
      iex> 1 + 1
    2
    """

    def f, do: :f
  end
end
