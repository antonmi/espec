# Code.require_file("test/docs/modules/mod1.ex")
Code.ensure_compiled(ESpec.Test.Docs.Mod1)


defmodule ESpec.DocExampleTest do

  use ExUnit.Case, async: true

  import ExUnit.TestHelpers

  defmodule ESpec.Test.Docs.Mod1 do
    @doc """
      iex> 1 + 1
      2
    """

    @doc """
      iex> 2 + 2
      5
    """

    def m, do: :m
  end |> write_beam

  test "Mod1" do
    # exs = ESpec.DocExample.extract(ESpec.Test.Docs.Mod1)
    # IO.inspect Code.compiler_options
    # IO.inspect Code.get_docs(ESpec.SomeModule, :all)
    IO.inspect Code.get_docs(ESpec.Test.Docs.Mod1, :all)
  end


end