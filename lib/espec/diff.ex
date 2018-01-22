defmodule ESpec.Diff do
  def diff(expected, actual) do
    diff = edit_script(actual, expected)
    format_diff(diff, {actual, expected})
  end

  # shamelessly copied from ex_unit/formatter
  defp edit_script(left, right) do
    task = Task.async(ExUnit.Diff, :script, [left, right])

    case Task.yield(task, 1_500) || Task.shutdown(task, :brutal_kill) do
      {:ok, script} -> script
      nil -> nil
    end
  end

  defp format_diff(diff, {actual, expected}) do
    if is_nil(diff) do
      {
        [eq: inspect(expected, printable_limit: :infinity)],
        [eq: inspect(actual, printable_limit: :infinity)]
      }
    else
      diff
      |> List.flatten()
      |> split_flattened_diff()
    end
  end

  defp split_flattened_diff(diff) do
    split_flattened_diff(diff, %{
      left: [],
      right: []
    })
  end

  defp split_flattened_diff([{:ins, text} | tail], processed) do
    split_flattened_diff(tail, Map.update!(processed, :left, &(&1 ++ [ins: text])))
  end

  defp split_flattened_diff([{:del, text} | tail], processed) do
    split_flattened_diff(tail, Map.update!(processed, :right, &(&1 ++ [del: text])))
  end

  defp split_flattened_diff([{:eq, text} | tail], processed) do
    processed =
      processed
      |> Map.update!(:right, &(&1 ++ [eq: text]))
      |> Map.update!(:left, &(&1 ++ [eq: text]))

    split_flattened_diff(tail, processed)
  end

  defp split_flattened_diff([], processed) do
    {processed.left, processed.right}
  end
end
