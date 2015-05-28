defmodule ESpec.AllowTo do
  
  require IEx

  def to(mock, {ESpec.AllowTo, module}) do
    case mock do
      {:accept, name, function} -> ESpec.Mock.expect(module, name, function)
      {:accept, list} when is_list(list)-> 
        if Keyword.keyword?(list) do
          Enum.each(list, fn({name, function}) -> 
            ESpec.Mock.expect(module, name, function)
          end)
        else
          Enum.each(list, &ESpec.Mock.expect(module, &1, fn -> end))
        end
      {:accept, name} -> ESpec.Mock.expect(module, name, fn -> end)  
    end
  end


end
