defmodule ESpec.To do

  def to(rhs, {ESpec.To, lhs}, positive \\ true) do
    case rhs do
      {:eq, value} -> ESpec.Assertions.Eq.assert(lhs, value, positive)
      # {:be, :>, value} -> ESpec.Assertions.GreaterThan.assert(lhs, value)
      {:be, true, _value} -> ESpec.Assertions.True.assert(lhs, _value, positive)
      {:be, false, _value} -> ESpec.Assertions.False.assert(lhs, _value, positive)
      {:be, nil, _value} -> ESpec.Assertions.Nil.assert(lhs, _value, positive)
      {:be, :between, value} -> ESpec.Assertions.Between.assert(lhs, value, positive)
      {:raise_exception, value} -> ESpec.Assertions.RaiseException.assert(lhs, value, positive)
      _ -> IO.puts "No match"
    end
  end

  def to_not(rhs, {ESpec.To, lhs}), do: to(rhs, {ESpec.To, lhs}, false)
end
