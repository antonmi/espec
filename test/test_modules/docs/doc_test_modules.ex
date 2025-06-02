defmodule TestModules.Docs.DocTestModules do
  defmodule Mod1 do
    @moduledoc """
      iex> 2 + 2
      4
    """

    @doc """
      iex> Enum.map [1, 2, 3], fn(x) ->
      ...>   x * 2
      ...> end
      [2,4,6]

      iex> 2 + 2
      5

      iex> TestModules.Docs.DocTestModules.Mod1.f
      :f
    """
    def f, do: :f
  end

  defmodule Mod2 do
    @doc """
      iex> TestModules.Docs.DocTestModules.Mod2.f1
      :f1
    """
    def f1, do: :f1

    @doc """
      iex> TestModules.Docs.DocTestModules.Mod2.f2
      :f2
    """
    def f2, do: :f2

    @doc """
      iex> TestModules.Docs.DocTestModules.Mod2.f3
      :f3
    """
    def f3, do: :f3

    @doc """
      iex> TestModules.Docs.DocTestModules.Mod2.f4
      :f4
    """
    def f4, do: :f4
  end

  defmodule Mod3 do
    @doc """
      iex> some_fun()
      :some_fun
    """
    def some_fun, do: :some_fun

    @doc """
      iex> some_fun(1, 1)
      2
    """
    def some_fun(a, b), do: a + b
  end

  defmodule Mod4 do
    @doc """
      iex(1)> apply(Kernel, :+, [:a, 1])
      ** (ArithmeticError) bad argument in arithmetic expression
          :erlang.+(:a, 1)
    """
    def f, do: :f
  end

  defmodule Mod5 do
    @doc """
      iex> Enum.into([a: 10, b: 20], Map.new)
      %{a: 10, b: 20}
    """
    def f, do: :f
  end

  defmodule Multiline do
    @doc """
    iex> a = Enum.map [1, 2, 3], fn(x) ->
    ...>   x * 2
    ...> end
    iex> b = [1 | a]
    iex> Enum.reverse(b)
    [6,4,2,1]
    """
    def f, do: :f

    @doc """
      iex> a = 1
      iex> 2 + a
      3
    """
    def ff, do: :ff

    @doc """
      iex> dict = Enum.into([a: 10, b: 20], Map.new)
      iex> Map.get(dict, :a)
      10
    """
    def fff, do: :fff
  end
end
