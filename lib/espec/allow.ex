defmodule ESpec.Allow do
  
  def allow(module), do: {ESpec.AllowTo, module}

  def receive(name, func) do
    {:receive, name, func}
  end
  
  def receive_messages(list) do
    {:receive_messages, list}
  end

end