defmodule ESpec.Assertions.ChangeTo do

  @behaviour ESpec.Assertion

  def assert(f1, [f2, value], positive \\ true) do
    unless success?(f1, f2, value, positive) do
      raise ESpec.AssertionError, act: f1, exp: [f2, value], message: error_message(f1, f2, value, positive)
    end
  end

  defp success?(f1, f2, value, positive) do
    if positive, do: match(f1, f2, value), else: !match(f1, f2, value)
  end

  defp match(f1, f2, value) do
    initial = f2.() 
    f1.() 
    then = f2.()
    initial != then && then == value
  end

  def error_message(f1, f2, value, positive) do
    to = if positive, do: "to", else: "not to"
    "Expected `#{inspect f1}` #{to} change the value of `#{inspect f2}` to `#{value}`"
  end

end
