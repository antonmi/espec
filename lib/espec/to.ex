defmodule ESpec.To do
  @moduledoc """
  Defines `to`, `to_not` and `not_to` helper functions.
  The functions implement syntax: 'expect 1 |> to eq 1'
  These functions wrap arguments for `ESpec.ExpectTo` module.

  Also defines `to` helper function for mocking without parenthesis:
  `allow SomeModule |> to accept(:f, fn(a) -> "mock" end)`
  These functions wrap arguments for `ESpec.AllowTo` module.
  """

  alias ESpec.AllowTo
  alias ESpec.ExpectTo

  @doc "Wrappers for `ESpec.AllowTo.to`."
  def to(module, {:accept, name, function}) when is_atom(name) do
    AllowTo.to({:accept, name, function}, {AllowTo, module})
  end

  def to(module, {:accept, name, function, meck_options})
      when is_atom(name) and is_list(meck_options) do
    AllowTo.to({:accept, name, function, meck_options}, {AllowTo, module})
  end

  def to(module, {:accept, list}) when is_list(list) do
    AllowTo.to({:accept, list}, {AllowTo, module})
  end

  def to(module, {:accept, list, meck_options}) when is_list(list) and is_list(meck_options) do
    AllowTo.to({:accept, list, meck_options}, {AllowTo, module})
  end

  def to(module, {:accept, name}) when is_atom(name) do
    AllowTo.to({:accept, name}, {AllowTo, module})
  end

  def to({ExpectTo, subject, stacktrace}, {module, data}) do
    ExpectTo.to({module, data}, {ExpectTo, subject, stacktrace})
  end

  def to(subject, {module, data}) do
    ExpectTo.to({module, data}, {ExpectTo, subject, ESpec.Expect.pruned_stacktrace()})
  end

  def to_not({ExpectTo, subject, stacktrace}, {module, data}) do
    ExpectTo.to_not({module, data}, {ExpectTo, subject, stacktrace})
  end

  def to_not(subject, {module, data}) do
    ExpectTo.to_not({module, data}, {ExpectTo, subject, ESpec.Expect.pruned_stacktrace()})
  end

  def not_to({ExpectTo, subject, stacktrace}, {module, data}) do
    to_not({ExpectTo, subject, stacktrace}, {module, data})
  end

  def not_to(subject, {module, data}) do
    to_not(subject, {module, data})
  end
end
