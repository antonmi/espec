defmodule ESpec.Assertions.ContainExactly do
  @moduledoc """
  Defines the 'contain_exactly' assertion (or match_list) - the lists
  have the same elements (possibly in a different order).

  it do: expect(actual).to contain_exactly(expected)
  it do: expect(actual).to match_list(expected)
  """
  use ESpec.Assertions.Interface

  defp sort_collection(collection) when is_list(collection) do
    if Keyword.keyword?(collection) do
      Enum.sort(collection, fn {k1, v1}, {k2, v2} ->
        if k1 == k2, do: v1 <= v2, else: k1 < k2
      end)
    else
      Enum.sort(collection)
    end
  end

  defp sort_collection(collection), do: collection

  defp diff(subject, data) do
    ESpec.Diff.diff(
      sort_collection(subject),
      sort_collection(data)
    )
  end

  defp match(expected, _actual) when not is_list(expected) do
    {false, false}
  end

  defp match(expected, actual) do
    result = Keyword.equal?(expected, actual)
    {result, result}
  end

  defp success_message(subject, data, _result, positive) do
    to = if positive, do: "contains exactly", else: "doesn't contain exactly"
    "`#{inspect(subject)}` #{to} `#{inspect(data)}`."
  end

  defp error_message(subject, data, _diff, positive) do
    to = if positive, do: "to", else: "not to"
    but = if positive, do: "doesn't", else: "does"
    m = "Expected `#{inspect(subject)}` #{to} contain exactly `#{inspect(data)}`, but it #{but}."

    if positive do
      {m, %{diff_fn: fn -> diff(subject, data) end}}
    else
      m
    end
  end
end
