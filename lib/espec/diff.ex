defmodule ESpec.Diff do
  def diff(expected, actual) do
    edit_script(actual, expected)
  end

  defp edit_script(left, right) do
    task =
      Task.async(ExUnit.Diff, :compute, [
        left,
        right,
        :===
      ])

    case Task.yield(task, 1_500) || Task.shutdown(task, :brutal_kill) do
      {:ok, {script, _}} -> script
      nil -> nil
    end
  end
end
