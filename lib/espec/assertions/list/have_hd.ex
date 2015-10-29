defmodule ESpec.Assertions.List.HaveHd do
  @moduledoc """
  Defines 'have_hd' assertion.

  it do: expect(list).to have_hd(value)
  """
  use ESpec.Assertions.Interface

  defp match(list, val) do
    result = hd(list)
    {result == val, result}
  end

  defp success_message(list, val, _result, positive) do
    to = if positive, do: "has", else: "doesn't have"
    "`#{inspect list}` #{to} `hd` == `#{inspect val}`."
  end

  defp error_message(list, val, result, positive) do
    to = if positive, do: "to", else: "not to"
    "Expected `#{inspect list}` #{to} have `hd` `#{val}` but it has `#{result}`."
  end
end
