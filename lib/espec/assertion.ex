defmodule ESpec.Assertion do

  def assert(:==, lhs, rhs) do
    if lhs == rhs do
      IO.write("\e[32;1m.\e[0m")
    else
      IO.write("\e[31;1mF\e[0m")
      raise ESpec.AssertionError, lhs: lhs, rhs: rhs, message: "ERROR"
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
