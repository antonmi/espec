defmodule ESpec.DocTestTest.Mod1 do
  @doc """
    iex> 1 + 1
    2

    iex> 2 + 2
    5
  """

  def f, do: :f
end |> ExUnit.TestHelpers.write_beam

defmodule ESpec.DocTestTest.SomeSpec do

  use ESpec

  doctest ESpec.DocTestTest.Mod1
  
end |> ExUnit.TestHelpers.write_beam


defmodule ESpec.DocTestTest do

  use ExUnit.Case, async: true


  test "Examples" do
    examples = ESpec.DocTestTest.SomeSpec.examples
    exs = ESpec.Runner.run_examples(examples)
    IO.inspect exs
  end




end