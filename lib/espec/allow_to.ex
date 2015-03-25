defmodule ESpec.AllowTo do
  
  require IEx

  def to(mock, {ESpec.AllowTo, module}, positive \\ true) do
    case mock do
      {:receive, name, function} -> ESpec.Mock.expect(module, name, function)
      {:receive_messages, list} -> 
        Enum.each(list, fn({name, function}) -> 
          ESpec.Mock.expect(module, name, function)
        end)
    end
  end


end
