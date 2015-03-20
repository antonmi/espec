defmodule ESpec.To do

  def to(rhs, {ESpec.To, lhs}, positive \\ true) do
    case rhs do
      {:eq, value} -> ESpec.Assertions.Eq.assert(lhs, value, positive)
      # {:be, :>, value} -> ESpec.Assertions.GreaterThan.assert(lhs, value)
      # {:be, true, value} -> ESpec.Assertions.True.assert(lhs, value)
      {:be, :between, [l, r]} -> ESpec.Assertions.Between.assert(lhs, [l, r], positive)
      _ -> IO.puts "No match"
    end
  end

  def to_not(rhs, {ESpec.To, lhs}), do: to(rhs, {ESpec.To, lhs}, false)
end
