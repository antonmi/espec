defmodule ESpec.Allow do
  @moduledoc """
  Defines helper functions for modules which use ESpec.
  These fucntions wrap arguments for ESpec.AllowTo module.
  """
  def allow(module), do: {ESpec.AllowTo, module}

  def accept(name, func) do
    {:accept, name, func}
  end
  
  def accept(list) do
    {:accept, list}
  end

  def passthrough(args), do: :meck.passthrough(args)
end
