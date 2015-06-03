defmodule ESpec.Allow do
  
  def allow(module), do: {ESpec.AllowTo, module}

  def accept(name, func) do
    {:accept, name, func}
  end
  
  def accept(list) do
    {:accept, list}
  end

  def passthrough(args), do: :meck.passthrough(args)
end