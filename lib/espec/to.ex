defmodule ESpec.To do
  @moduledoc """
    Defines `to` and `to_not` functions which call specific 'assertion'
  """

  @doc "Calls specific asserion."
  def to(rhs, {ESpec.To, lhs}, positive \\ true) do
    case rhs do
      {:eq, value} -> ESpec.Assertions.Eq.assert(lhs, value, positive)
      {:eql, value} -> ESpec.Assertions.Eql.assert(lhs, value, positive)
      {:be, op, value} when op in ~w(> < >= <= == != === !== <> =~)a ->
        ESpec.Assertions.Be.assert(lhs, [op, value], positive) #TODO
      {:be_between, min, max} -> ESpec.Assertions.BeBetween.assert(lhs, [min, max], positive)
      {:be_close, value, delta} -> ESpec.Assertions.BeCloseTo.assert(lhs, [value, delta], positive)
      {:match, value} -> ESpec.Assertions.Match.assert(lhs, value, positive)
      {:raise_exception, value} -> ESpec.Assertions.RaiseException.assert(lhs, value, positive)
      {:throw_term, value} -> ESpec.Assertions.ThrowTerm.assert(lhs, value, positive)
      {:change_to, func, value} -> ESpec.Assertions.ChangeTo.assert(lhs, [func, value], positive)
      {:change_from_to, func, [before, value]} -> ESpec.Assertions.ChangeFromTo.assert(lhs, [func, before, value], positive)
      {:accepted, func, args} -> ESpec.Assertions.Accepted.assert(lhs, [func, args], positive)
    end
  end

  @doc "Just `to` with `positive = false`."
  def to_not(rhs, {ESpec.To, lhs}), do: to(rhs, {ESpec.To, lhs}, false)

  @doc "Alias fo `to_not`."
  def not_to(rhs, {ESpec.To, lhs}), do: to(rhs, {ESpec.To, lhs}, false)
end


