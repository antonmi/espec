defmodule ESpec.DocTestTest.Mod1 do
  @doc """
    iex> Enum.map [1, 2, 3], fn(x) ->
    ...>   x * 2
    ...> end
    [2,4,6]

    iex> 2 + 2
    4

    iex> Enum.into([a: 10, b: 20], HashDict.new)
    #HashDict<[b: 20, a: 10]>

    iex> ESpec.DocTestTest.Mod1.f
    :f

    iex> a = 1
    iex> 1 + a
    2
    iex> 2 + a
    3

    iex> dict = Enum.into([a: 10, b: 20], Map.new)
    iex> Map.get(dict, :a)
    10
  """
  def f, do: :f
end |> ESpec.TestHelpers.write_beam

defmodule DocTestSpec do
  use ESpec

  doctest ESpec.DocTestTest.Mod1

  it do: expect(ESpec.DocTestTest.Mod1.f).to eq(:f)
end
