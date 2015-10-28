defmodule ESpec.To do
  @moduledoc """
  Defines `to`, `to_not` and `not_to` helper functions.
  The functions implement syntax: expect 1 |> to eq 1
  These functions wrap arguments for ESpec.ExpectTo module.
  """

  @doc "Special case for `is_expected` when `subject` present."
  def to({ESpec.ExpectTo, subject}, {module, data}), do: to(subject, {module, data})

  @doc "Wrapper for `ESpec.ExpectTo.to`."
  def to(subject, {module, data}) do
    ESpec.ExpectTo.to({module, data}, {ESpec.ExpectTo, subject})
  end

  @doc "Special case for `is_expected` when `subject` present."
  def to_not({ESpec.ExpectTo, subject}, {module, data}), do: to_not(subject, {module, data})

  @doc "Wrapper for `ESpec.ExpectTo.to_not`."
  def to_not(subject, {module, data}) do
    ESpec.ExpectTo.to_not({module, data}, {ESpec.ExpectTo, subject})
  end

  @doc "Special case for `is_expected` when `subject` present."
  def not_to({ESpec.ExpectTo, subject}, {module, data}), do: not_to(subject, {module, data})

  @doc "Wrapper for `ESpec.ExpectTo.not_to`."
  def not_to(subject, {module, data}), do: to_not(subject, {module, data})
end
