defmodule ESpec.Assertions.String.EndWith do
  @moduledoc """
  Defines 'end_with' assertion.

  it do: expect(string).to end_with(value)
  """
  use ESpec.Assertions.Interface

  defp match(string, val) do
    result = String.ends_with?(string, val)

    if result do
      {result, val}
    else
      val = if is_list(val), do: List.first(val), else: val

      length_l = String.length(string)
      length_r = String.length(val)

      if length_l <= length_r do
        {result, string}
      else
        {_, ends} = String.split_at(string, length_l - length_r)
        {result, ends}
      end
    end
  end

  defp success_message(string, val, _result, positive) do
    to = if positive, do: "ends", else: "doesn't end"
    "`#{inspect(string)}` #{to} with `#{inspect(val)}`."
  end

  defp error_message(string, val, result, positive) do
    to = if positive, do: "to", else: "not to"
    m = "Expected `#{inspect(string)}` #{to} end with `#{val}` but it ends with `#{result}`."

    if positive do
      {m, %{diff_fn: fn -> ESpec.Diff.diff(result, val) end}}
    else
      m
    end
  end
end
