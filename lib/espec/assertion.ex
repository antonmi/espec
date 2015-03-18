defmodule Espec.Assertion do

  def assert(:==, lhs, rhs) do
    if lhs == rhs do
      IO.write(".")
    else
      IO.write("F")
    end
  end

  def assert(:>, lhs, rhs) do
    if lhs > rhs do
      IO.write(".")
    else
      IO.write("F")
    end
  end

  def assert(true, lhs, _rhs) do
    if lhs == true do
      IO.write(".")
    else
      IO.write("F")
    end
  end

  def assert(:between, value, lhs, rhs) do
    IO.puts lhs
    IO.puts rhs
    IO.puts value
    if value >= lhs && value <= rhs do
      IO.write(".")
    else
      IO.write("F")
    end
  end

end
