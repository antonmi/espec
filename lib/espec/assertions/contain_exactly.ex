defmodule ESpec.Assertions.ContainExactly do
  @moduledoc """
  Defines the 'contain_exactly' assertion (or match_list) - the lists
  have the same elements (possibly in a different order).

  it do: expect(actual).to contain_exactly(expected)
  it do: expect(actual).to match_list(expected)
  """
  use ESpec.Assertions.Interface

  defp sort_collection(collection) do
    if Keyword.keyword?(collection) do
      Enum.sort(collection, fn({k1, v1}, {k2, v2}) ->
        if k1 == k2, do: v1 <= v2, else: k1 < k2
      end)
    else
      Enum.sort(collection)
    end
  end

  defp match(expected, actual) when not is_list(expected) do
    {false, {[ins: inspect(expected)], [del: inspect(actual)]}}
  end

  defp match(expected, actual) do
    result = Keyword.equal?(expected, actual)
    diff =
      if result do
        nil
      else
         diff(expected, actual)
       end
    {result, diff}
  end

  defp diff(expected, actual) do
    ExUnit.Diff.script(sort_collection(actual), sort_collection(expected))
    |> List.flatten
    |> align_eq_in_diff(%{
        left: [], left_whitespace_width: 0,
        right: [], right_whitespace_width: 0
      })
  end

  defp align_eq_in_diff([{:ins, text} | tail], processed) do
    processed =
      processed
      |> Map.update!(:left, &(&1 ++ [ins: text]))
      |> Map.update!(:right_whitespace_width, &(&1 + String.length(text)))

    align_eq_in_diff(tail, processed)
  end

  defp align_eq_in_diff([{:del, text} | tail], processed) do
    processed =
      processed
      |> Map.update!(:right, &(&1 ++ [del: text]))
      |> Map.update!(:left_whitespace_width, &(&1 + String.length(text)))

    align_eq_in_diff(tail, processed)
  end

  defp align_eq_in_diff([{:eq, text} | tail], %{left_whitespace_width: l, right_whitespace_width: r} = processed) do
    to_add = abs(l - r)
    left_whitespace = if l > r, do: [ins_whitespace: to_add], else: []
    right_whitespace = if r > l, do: [ins_whitespace: to_add], else: []

    processed =
      processed
      |> Map.update!(:right, &(&1 ++ right_whitespace ++ [eq: text]))
      |> Map.put(:left_whitespace_width, 0)
      |> Map.update!(:left, &(&1 ++ left_whitespace ++ [eq: text]))
      |> Map.put(:right_whitespace_width, 0)

    align_eq_in_diff(tail, processed)
  end

  defp align_eq_in_diff([], processed) do
    {processed.left, processed.right}
  end

  defp success_message(subject, data, _result, positive) do
    to = if positive, do: "contains exactly", else: "doesn't contain exactly"
    "`#{inspect subject}` #{to} `#{inspect data}`."
  end

  defp error_message(subject, data, _diff, positive) do
    to = if positive, do: "to", else: "not to"
    but = if positive, do: "doesn't", else: "does"
    "Expected `#{inspect subject}` #{to} contain exactly `#{inspect data}`, but it #{but}."
  end
end
