defmodule ESpec.Assertions.List.HaveTl do
  @moduledoc """
  Defines 'have_tl' assertion.

  it do: expect(list).to have_tl(value)
  """
  use ESpec.Assertions.Interface

  defp match(list, val) do
    result = tl(list)
    {result == val, result}
  end

  defp success_message(list, val, _result, positive) do
    to = if positive, do: "has", else: "doesn't have"
    "`#{inspect(list)}` #{to} `tl` == `#{inspect(val)}`."
  end

  defp error_message(list, val, result, positive) do
    to = if positive, do: "to", else: "not to"

    m =
      "Expected `#{inspect(list)}` #{to} have `tl` `#{inspect(val)}` but it has `#{inspect(result)}`."

    if positive and not is_binary(list) do
      {m, %{diff_fn: fn -> ESpec.Diff.diff(tl(list), val) end}}
    else
      {m, nil}
    end
  end
end
