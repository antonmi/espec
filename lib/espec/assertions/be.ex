defmodule ESpec.Assertions.Be do

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
    [op, val] = exp
    apply(Kernel, op, [act, val])
  end

  def error_message(act, exp, positive) do
    [op, val] = exp
    "Expected `#{inspect act} #{op} #{inspect val}` to be #{positive} but got #{!positive}"
  end

end
