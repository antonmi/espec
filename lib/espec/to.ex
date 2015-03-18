defmodule Espec.To do

  def to(rhs, {Espec.To, lhs}) do
    case rhs do
      {:eq, value} -> Espec.Assertion.assert(:==, lhs, value)
      {:be, :>, value} -> Espec.Assertion.assert(:>, lhs, value)
      {:be, true, value} -> Espec.Assertion.assert(:>, lhs, value)
      {:be, :between, [l, r]} -> Espec.Assertion.assert(:between, lhs, l, r)
      _ -> IO.puts "No match"
    end
  end
end
