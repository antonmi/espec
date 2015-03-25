defmodule ESpec.Allow do
  
  def allow(value), do: {ESpec.AllowTo, value}

  def receive(name, func) do
    {:receive, name, func}
  end
  
end