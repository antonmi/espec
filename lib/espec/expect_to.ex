defmodule ESpec.ExpectTo do
  @moduledoc """
    Defines `to` and `to_not` functions which call specific 'assertion'
  """
  @agent_name :espec_expect_to_agent

  @doc "Calls specific asserion."
  def to({module, data}, {ESpec.ExpectTo, subject}) do
    apply(module, :assert, [subject, data, true])
  end

  @doc "Just apply 'assert' with `positive = false`."
  def to_not({module, data}, {ESpec.ExpectTo, subject}) do
    apply(module, :assert, [subject, data, false])
  end

  @doc "Alias fo `to_not`."
  def not_to(rhs, {ESpec.ExpectTo, subject}), do: to_not(rhs, {ESpec.ExpectTo, subject})
end
