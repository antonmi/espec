defmodule ESpec.AllowTo do
  
  require IEx

  def to(mock, {ESpec.AllowTo, module}) do
    case mock do
      {:accept, name, function} -> ESpec.Mock.expect(module, name, function)
      {:accept, list} -> 
        Enum.each(list, fn({name, function}) -> 
          ESpec.Mock.expect(module, name, function)
        end)
    end
  end


end
