defmodule ESpec.Assertions.Enum.HaveAt do

  @behaviour ESpec.Assertion

  def assert(enum, [pos, val], positive \\ true) do
    unless success?(enum, [pos, val], positive) do
      raise ESpec.AssertionError, act: enum, exp: [pos, val], message: error_message(enum, [pos, val], positive)
    end
  end

  defp success?(enum, [pos, val], positive) do
    if positive, do: match(enum, [pos, val]), else: !match(enum, [pos, val])
  end

  defp match(enum, [pos, val]) do
    Enum.at(enum, pos) == val
  end

  def error_message(enum, [pos, val], positive) do
    to = if positive, do: "to", else: "to"
    "Expected `#{inspect enum}` #{to} to have `#{inspect val}` on `#{inspect pos}` position"
  end


end