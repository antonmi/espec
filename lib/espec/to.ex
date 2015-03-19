defmodule ESpec.To do

  def to(rhs, {ESpec.To, lhs}) do
    case rhs do
      {:eq, value} -> ESpec.Assertion.assert(:==, lhs, value)
      {:be, :>, value} -> ESpec.Assertion.assert(:>, lhs, value)
      {:be, true, value} -> ESpec.Assertion.assert(:>, lhs, value)
      {:be, :between, [l, r]} -> ESpec.Assertion.assert(:between, lhs, l, r)
      _ -> IO.puts "No match"
    end
  end
end
