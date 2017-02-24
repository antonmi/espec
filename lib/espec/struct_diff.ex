defmodule ESpec.StructDiff do
  @max_diffs_to_show 5
  def format_diff(a, b, prefix\\''), do: diff(a,b) |> format(prefix)

  def diff(a, b) when a == b, do: %{}
  def diff(a, b) when is_list(a) and is_list(b) and length(a) == length(b) do
    diff_enumerables(a, b) |> simplify(b)
  end
  def diff(a, b) when is_list(a) and is_list(b) and length(a) < length(b) do
    diff(append_nils(a, b), b)
  end
  def diff(a, b) when is_list(a) and is_list(b) and length(a) > length(b) do
    diff(a, append_nils(b, a))
  end

  def diff(a, b) when is_tuple(a) and is_tuple(b) do
    diff(Tuple.to_list(a), Tuple.to_list(b))
  end

  def diff(a, b) when is_map(a) and is_map(b) do
    a_keys = a |> Map.keys |> MapSet.new
    b_keys = b |> Map.keys |> MapSet.new

    res = %{
      :- => a_keys |> MapSet.difference(b_keys) |> Enum.to_list,
      :+ => b_keys |> MapSet.difference(a_keys) |> Enum.to_list,
    }
    |> Enum.reject(fn {_, v} -> v == [] end)
    |> Map.new

    MapSet.intersection(a_keys, b_keys)
    |> Enum.reduce(res, fn k, acc ->
      acc |> Map.merge(diff(a[k], b[k]) |> wrap_ctx(k))
    end)
    |> simplify(b)
  end
  def diff(a, b) when a != b, do: %{:!= => b}

  def append_nils(shorter, longer) do
    length_diff = length(longer) - length(shorter)
    shorter ++ Enum.map(1..length_diff, fn(_) -> nil end)
  end

  def format(diffmap, prefix\\"") when is_map(diffmap) do
    [format_lines(diffmap)]
    |> List.flatten
    |> Enum.map(&"#{prefix}#{&1}\n")
    |> Enum.join
  end

  def format_lines({:!=, b}), do: "got: `#{inspect(b)}`"
  def format_lines({:+, l}),  do: "has extra: `#{inspect l}`"
  def format_lines({:-, l}),  do: "missing: `#{inspect l}`"
  def format_lines({ctx, diffmap}) when is_map(diffmap) do
    ["at #{key(ctx)}:"]
    ++ (format_lines(diffmap) |> indent)
  end
  def format_lines(diffmap) when map_size(diffmap) == 0, do: "Values completely match"
  def format_lines(diffmap) do
    diffmap |> Enum.flat_map(fn edit ->
      [edit |> format_lines] |> List.flatten
    end)
  end

  # Privates
  defp indent([]), do: []
  defp indent([line|lines]), do: [indent(line)] ++ indent(lines)
  defp indent(line), do: "  #{line}"

  defp diff_enumerables(a,b) do
    Enum.zip(a,b)
    |> Enum.with_index
    |> Enum.reduce(%{}, fn {{a, b}, i}, acc ->
      acc |> Map.merge(diff(a, b) |> wrap_ctx(i))
    end)
  end

  defp wrap_ctx(edits, key) do
    case edits |> Map.keys do
      []                  -> %{}
      [k] when is_list(k) -> %{[key]++k => edits[k]}
      _                   -> %{[key] => edits}
    end
  end

  defp simplify(edits, _) when map_size(edits) <= @max_diffs_to_show, do: edits
  defp simplify(_, b), do: %{:!= => b}

  defp key([]), do: ''
  defp key([k|t]), do: "[#{inspect k}]#{key t}"
end
