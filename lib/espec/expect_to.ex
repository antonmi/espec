defmodule ESpec.ExpectTo do
  @moduledoc """
    Defines `to` and `to_not` functions which call specific 'assertion'
  """
  @agent_name :espec_expect_to_agent

  @doc "Calls specific asserion."
  def to({key, data}, {ESpec.ExpectTo, subject}, positive \\ true) do
    module = ESpec.Assertions.agent_get(key)
    apply(module, :assert, [subject, data, positive])
  end

  @doc "Just `to` with `positive = false`."
  def to_not(rhs, {ESpec.ExpectTo, subject}), do: to(rhs, {ESpec.ExpectTo, subject}, false)

  @doc "Alias fo `to_not`."
  def not_to(rhs, {ESpec.ExpectTo, subject}), do: to(rhs, {ESpec.ExpectTo, subject}, false)

  
end


