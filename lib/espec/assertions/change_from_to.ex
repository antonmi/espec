defmodule ESpec.Assertions.ChangeFromTo do

  @behaviour ESpec.Assertion

  def assert(f1, [f2, before, value], positive \\ true) do
    unless success?(f1, f2, before, value, positive) do
      raise ESpec.AssertionError, act: f1, exp: [f2, value], message: error_message(f1, f2, before, value, positive)
    end
  end

  defp success?(f1, f2, before, value, positive) do
    if positive, do: match(f1, f2, before, value), else: !match(f1, f2, before, value)
  end

  defp match(f1, f2, before, value) do
    initial = f2.() 
    f1.() 
    then = f2.()
    initial == before && then == value
  end

  def error_message(f1, f2, before, value, positive) do
    to = if positive, do: "to", else: "not to"
    "Expected `#{inspect f1}` #{to} change the value of `#{inspect f2}` from `#{before}` to `#{value}`"
  end

end
