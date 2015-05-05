defmodule ESpec.DocTest do


  defmacro doctest(module, opts \\ []) do

    quote do
      # IO.inspect unquote(module)
      # ESpec.DocExample.extract(unquote(module))
      Enum.each(1..3, fn(ex) -> 
      
        a = 1
        example do
          IO.inspect a
        end

      end)
    end
  end

  

end