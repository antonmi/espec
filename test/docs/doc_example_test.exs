defmodule ESpec.Docs.DocExampleTest do
  use ExUnit.Case, async: true
  import ExUnit.TestHelpers

  defmodule Mod1 do
    @doc """
      iex> 1 + 1
      2

      iex> 2 + 2
      5
    """
    def f, do: :f
  end
  |> write_beam

  test "Mod1" do
    examples = ESpec.DocExample.extract(Mod1)
    assert length(examples) == 2

    ex = hd(examples)
    assert ex.lhs == "1 + 1"
    assert ex.rhs == "2"
    assert ex.fun_arity == {:f, 0}
  end

  defmodule Mod2 do
    @doc """
      iex> 1 + 1
    2
    """

    def f, do: :f
  end
  |> write_beam

  test "Mod2" do
    assert_raise ESpec.DocExample.Error,
                 "indentation level mismatch: \"2\", should have been 2 spaces",
                 fn ->
                   ESpec.DocExample.extract(Mod2)
                 end
  end
end
