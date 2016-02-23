defmodule ESpec.ExpectTo do
  @moduledoc """
    Defines `to` and `to_not` functions which call specific 'assertion'
  """
  @agent_name :espec_expect_to_agent

  @doc "Calls specific asserion."
  def to({module, data}, {__MODULE__, subject}) do
    apply(module, :assert, [subject, data, true])
  end

  @doc "Just apply 'assert' with `positive = false`."
  def to_not({module, data}, {__MODULE__, subject}) do
    apply(module, :assert, [subject, data, false])
  end

  @doc "Alias fo `to_not`."
  def not_to(rhs, {__MODULE__, subject}), do: to_not(rhs, {__MODULE__, subject})
end
