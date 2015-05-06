defmodule ESpec.DocTestTest.Mod1 do
  @doc """
    iex> Enum.map [1, 2, 3], fn(x) ->
    ...>   x * 2
    ...> end
    [2,4,6]

    iex> 2 + 2
    4

    iex> ESpec.DocTestTest.Mod1.f
    :f
  """
  def f, do: :f
end |> ESpec.TestHelpers.write_beam

defmodule DocTestSpec do
  use ESpec
  
  doctest ESpec.DocTestTest.Mod1

  it do: expect(ESpec.DocTestTest.Mod1.f).to eq(:f)
end


