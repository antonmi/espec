defmodule ESpec.Assert do
  @moduledoc """
  Defines `assert` and `refute` helper functions.
  """

  alias ESpec.ExpectTo
  alias ESpec.Assertions.Boolean.BeTruthy
  alias ESpec.Assertions.Boolean.BeFalsy

  @doc "Calls be_truthy assertion"
  def assert(value), do: ExpectTo.to({BeTruthy, []}, {ExpectTo, value})

  @doc "Calls be_falsy assertion"
  def refute(value), do: ExpectTo.to({BeFalsy, []}, {ExpectTo, value})
end
