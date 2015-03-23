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
    {res, _} = Code.eval_string("act #{op} val", [act: act, val: val], file: __ENV__.file, line: __ENV__.line)
    res
  end

  def error_message(act, exp, positive) do
    [op, val] = exp
    "Expected `#{act} #{op} #{val}` to be #{positive} but got #{!positive}"
  end

end
