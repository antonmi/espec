defmodule ESpec.Assertions.String.StartWith do
  @moduledoc """
  Defines 'start_with' assertion.

  it do: expect(string).to start_with(value)
  """
  use ESpec.Assertions.Interface

  defp match(string, val) do
    result = String.starts_with?(string, val)

    if result do
      {result, val}
    else
      val = if is_list(val), do: List.first(val), else: val

      length_l = String.length(string)
      length_r = String.length(val)

      if length_l <= length_r do
        {result, string}
      else
        {start, _} = String.split_at(string, length_r)
        {result, start}
      end
    end
  end

  defp success_message(string, val, _result, positive) do
    to = if positive, do: "starts", else: "doesn't start"
    "`#{inspect(string)}` #{to} with `#{inspect(val)}`."
  end

  defp error_message(string, val, result, positive) do
    to = if positive, do: "to", else: "not to"
    m = "Expected `#{inspect(string)}` #{to} start with `#{val}` but it starts with `#{result}`."

    if positive do
      {m, %{diff_fn: fn -> ESpec.Diff.diff(result, val) end}}
    else
      {m, nil}
    end
  end
end
