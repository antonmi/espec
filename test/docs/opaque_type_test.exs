defmodule ESpec.DocTestTest.Mod5 do
  @doc """
    iex> Enum.into([a: 10, b: 20], Map.new)
    %{a: 10, b: 20}
  """
  def f, do: :f
end |> ExUnit.TestHelpers.write_beam

defmodule ESpec.DocTestTest.OpaqueTypeSpec do
  use ESpec
  doctest ESpec.DocTestTest.Mod5
end |> ExUnit.TestHelpers.write_beam

defmodule ESpec.Docs.OpaqueTypeTest do
  use ExUnit.Case, async: true

  setup do
    examples = ESpec.DocTestTest.OpaqueTypeSpec.examples
    {:ok,
      ex1: Enum.at(examples, 0)
    }
  end

  test "ex1", context do
    ex = ESpec.ExampleRunner.run(context[:ex1])
    assert ex.status == :success
  end
end
