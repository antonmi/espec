defmodule ESpec.Allow do
  @moduledoc """
  Defines helper functions for mocking and stubbinf.
  These fucntions wrap arguments for ESpec.AllowTo module.
  """
  @doc "Wrapper for `ESpec.AllowTo`."
  def allow(module), do: {ESpec.AllowTo, module}

  @doc "Wraps arguments for `ESpec.AllowTo.to/2`."
  def accept(name, func), do: {:accept, name, func}
  def accept(name, func, meck_options), do: {:accept, name, func, meck_options}
  def accept(list), do: {:accept, list}
  def accept(list, meck_options), do: {:accept, list, meck_options}

  @doc "Delegates to `:meck.passthrough/1`."
  def passthrough(args), do: :meck.passthrough(args)
end
