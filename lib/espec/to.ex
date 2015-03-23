defmodule ESpec.To do

  def to(rhs, {ESpec.To, lhs}, positive \\ true) do
    case rhs do
      {:eq, value} -> ESpec.Assertions.Eq.assert(lhs, value, positive)
      # {:be, :>, value} -> ESpec.Assertions.GreaterThan.assert(lhs, value)
      {:be, :between, value} -> ESpec.Assertions.Between.assert(lhs, value, positive)
      {:raise_exception, value} -> ESpec.Assertions.RaiseException.assert(lhs, value, positive)
    end
  end

  def to_not(rhs, {ESpec.To, lhs}), do: to(rhs, {ESpec.To, lhs}, false)
end
