defmodule FindAssignmentsSpec do
  use ESpec

  let :first, do: {:=, [], [{:result, [], Let.QuoteAnalyzerTest}, 45]}
  let :second, do: {:=, [], [{{:a, [], Let.QuoteAnalyzerTest}, {:b, [], Let.QuoteAnalyzerTest}}, {1, 2}]}
  let :third, do: {:=, [], [{:ok, {:result, [], Let.QuoteAnalyzerTest}}, {:ok, 123}]}
  let :fourth, do: {:=, [], [{:error, {:result, [], Let.QuoteAnalyzerTest}}, {:error, 45}]}
  let :fifth, do: {:=, [], [{{:result, [], Let.QuoteAnalyzerTest}, :error}, {42, :error}]}
  let :sixth, do: {:=, [], [{:{}, [], [:ok, :error, {:result, [], Let.QuoteAnalyzerTest}]}, {:{}, [], [:ok, :error, 45]}]}
  let :seventh, do: {:=, [], [{:{}, [], [:ok, {:result, [], Let.QuoteAnalyzerTest}, {:heck, [], Let.QuoteAnalyzerTest}]}, {:{}, [], [:ok, 123, 42]}]}
  let :eighth, do: {:=, [], [{:{}, [], [{:a, [], Let.QuoteAnalyzerTest}, {:b, [], Let.QuoteAnalyzerTest}, {:c, [], Let.QuoteAnalyzerTest}]}, {:{}, [], [1, 2, 3]}]}

  def find({:=, _, [left, _right]}), do: find_assignments(left, [])

  def find_assignments({assignment, _, module}, acc) when is_atom(module), do: [assignment | acc]
  def find_assignments(atom, acc) when is_atom(atom), do: acc
  def find_assignments({left, right}, acc) do
    find_assignments(left, []) ++ acc ++ find_assignments(right, [])
  end
  def find_assignments({:{}, _, list}, acc) when is_list(list) do
    Enum.reduce(list, acc, fn(el, acc) -> find_assignments(el, []) ++ acc end)
  end

  it do: find(first) |> should(eq [:result])
  it do: find(second) |> should(eq [:a, :b])
  it do: find(third) |> should(eq [:result])
  it do: find(fourth) |> should(eq [:result])
  it do: find(fifth) |> should(eq [:result])
  it do: find(sixth) |> should(eq [:result])
  it do: find(seventh) |> should(eq [:heck, :result])
  it do: find(eighth) |> should(eq [:c, :b, :a])
end
