defmodule ESpec.ExpectTo do
  @moduledoc """
    Defines `to` and `to_not` functions which call specific 'assertion'
  """

  @doc "Calls specific asserion."
  def to({module, data}, {__MODULE__, subject, stacktrace}) do
    apply(module, :assert, [subject, data, true, stacktrace])
  end

  @doc "Just apply 'assert' with `positive = false`."
  def to_not({module, data}, {__MODULE__, subject, stacktrace}) do
    apply(module, :assert, [subject, data, false, stacktrace])
  end

  @doc "Alias fo `to_not`."
  def not_to(rhs, {__MODULE__, subject, stacktrace}), do: to_not(rhs, {__MODULE__, subject, stacktrace})
end
