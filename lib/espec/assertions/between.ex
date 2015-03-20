defmodule ESpec.Assertions.Between do

  @behaviour ESpec.Assertion

  def assert(act, exp, positive \\ true) do
    unless success?(act, exp, positive) do
      raise ESpec.AssertionError, act: act, exp: exp, message: error_message(act, exp, positive)
    end
  end

  defp success?(act, exp, positive) do
    if positive, do: match(act, exp), else: !match(act, exp)
  end

  defp match(act, exp) do
    act == exp
  end

  def error_message(act, exp, positive) do
    to = if positive, do: "to", else: "not to"
    "Expected #{act} #{to} equals #{exp}"
  end

end
