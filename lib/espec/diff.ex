defmodule ESpec.Diff do
  def diff(expected, actual) do
    diff = edit_script(actual, expected)
    format_diff(diff, {actual, expected}, false)
  end

  def diff_with_aligned_eq(expected, actual) do
    diff = edit_script(actual, expected)
    format_diff(diff, {actual, expected}, true)
  end

  # shamelessly copied from ex_unit/formatter
  defp edit_script(left, right) do
    task = Task.async(ExUnit.Diff, :script, [left, right])
    case Task.yield(task, 1_500) || Task.shutdown(task, :brutal_kill) do
      {:ok, script} -> script
      nil -> nil
    end
  end

  defp format_diff(diff, {actual, expected}, align_eq) do
    if is_nil(diff) do
      {
        [eq: inspect(expected, printable_limit: :infinity)],
        [eq: inspect(actual, printable_limit: :infinity)]
      }
    else
      diff
      |> List.flatten
      |> split_flattened_diff(align_eq)
    end
  end

  defp split_flattened_diff(diff, align_eq) when is_boolean(align_eq) do
    split_flattened_diff(diff, %{
        left: [],
        left_whitespace_width: 0,
        right: [],
        right_whitespace_width: 0,
        align_eq: align_eq
      })
  end

  defp split_flattened_diff([{:ins, text} | tail], %{align_eq: false} = processed) do
    split_flattened_diff(tail, Map.update!(processed, :left, &(&1 ++ [ins: text])))
  end

  defp split_flattened_diff([{:ins, text} | tail], processed) do
    processed =
      processed
      |> Map.update!(:left, &(&1 ++ [ins: text]))
      |> Map.update!(:right_whitespace_width, &(&1 + String.length(text)))

    split_flattened_diff(tail, processed)
  end

  defp split_flattened_diff([{:del, text} | tail], %{align_eq: false} = processed) do
    split_flattened_diff(tail, Map.update!(processed, :right, &(&1 ++ [del: text])))
  end

  defp split_flattened_diff([{:del, text} | tail], processed) do
    processed =
      processed
      |> Map.update!(:right, &(&1 ++ [del: text]))
      |> Map.update!(:left_whitespace_width, &(&1 + String.length(text)))

    split_flattened_diff(tail, processed)
  end

  defp split_flattened_diff([{:eq, text} | tail], %{align_eq: false} = processed) do
    processed =
      processed
      |> Map.update!(:right, &(&1 ++ [eq: text]))
      |> Map.update!(:left, &(&1 ++ [eq: text]))

    split_flattened_diff(tail, processed)
  end

  defp split_flattened_diff([{:eq, text} | tail], processed) do
    %{left_whitespace_width: l, right_whitespace_width: r} = processed
    to_add = abs(l - r)
    left_whitespace = if l > r, do: [ins_whitespace: to_add], else: []
    right_whitespace = if r > l, do: [ins_whitespace: to_add], else: []

    processed =
      processed
      |> Map.update!(:right, &(&1 ++ right_whitespace ++ [eq: text]))
      |> Map.put(:left_whitespace_width, 0)
      |> Map.update!(:left, &(&1 ++ left_whitespace ++ [eq: text]))
      |> Map.put(:right_whitespace_width, 0)

    split_flattened_diff(tail, processed)
  end

  defp split_flattened_diff([], processed) do
    {processed.left, processed.right}
  end
end
