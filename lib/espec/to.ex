defmodule ESpec.To do


  def to(rhs, {ESpec.To, lhs}, positive \\ true) do
    case rhs do
      {:eq, value} -> ESpec.Assertions.Eq.assert(lhs, value, positive)
      {:eql, value} -> ESpec.Assertions.Eql.assert(lhs, value, positive)
      {:be, op, value} when op in ~w(> < >= <= == != === !== <> =~)a ->
        ESpec.Assertions.Be.assert(lhs, [op, value], positive) #TODO
      {:be_between, min, max} -> ESpec.Assertions.Between.assert(lhs, [min, max], positive)
      {:be_close, value, delta} -> ESpec.Assertions.BeCloseTo.assert(lhs, [value, delta], positive)
      {:match, value} -> ESpec.Assertions.Match.assert(lhs, value, positive)
      {:raise_exception, value} -> ESpec.Assertions.RaiseException.assert(lhs, value, positive)
    end
  end

  def to_not(rhs, {ESpec.To, lhs}), do: to(rhs, {ESpec.To, lhs}, false)
end
