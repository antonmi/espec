defmodule ESpec.Assertions.Enum.HaveAll do

  @behaviour ESpec.Assertion

  def assert(enum, func, positive \\ true) do
    unless success?(enum, func, positive) do
      raise ESpec.AssertionError, act: enum, exp: func, message: error_message(enum, func, positive)
    end
  end

  defp success?(enum, func, positive) do
    if positive, do: match(enum, func), else: !match(enum, func)
  end

  defp match(enum, func) do
    Enum.all?(enum, func)
  end

  def error_message(enum, func, positive) do
    to = if positive, do: "to", else: "to"
    "Expected #{inspect func} #{to} return true for all elements in #{inspect enum}"
  end


end