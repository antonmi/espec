defmodule ESpec.Assertions.Eq do
  @moduledoc """
  Defines 'eq' (==) assertion.

  it do: expect(actual).to eq(expected)
  """
  use ESpec.Assertions.Interface

  alias ESpec.StructDiff

  defp match(subject, value) do
    result = subject == value
    {result, result}
  end

  defp success_message(subject, data, _result, positive) do
    to = if positive, do: "equals", else: "doesn't equal"
    "`#{inspect subject}` #{to} `#{inspect data}`."
  end

  defp error_message(subject, data, _result, positive) do
    expected = if positive, do: "Expected", else: "Didn't expect"
    but = if positive do
      StructDiff.diff(data, subject)
      |> StructDiff.format_lines
      |> format_diff
    else
      "got it"
    end
    "#{expected} (==) `#{inspect data}`, but #{but}"
  end

  defp format_diff([line]), do: line
  defp format_diff(lines), do: ([""] ++ lines) |> Enum.join("\n")
end
