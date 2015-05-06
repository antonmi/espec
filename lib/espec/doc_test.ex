defmodule ESpec.DocTest do


  defmacro doctest(module, opts \\ []) do

    quote do
      # IO.inspect unquote(module)
      ESpec.DocExample.extract(unquote(module))
      |> Enum.each(fn(ex) -> 
      
        IO.inspect ex
        {lhs, _} = Code.eval_string(ex.lhs)
        {rhs, _} = Code.eval_string(ex.rhs)
        example do
          expect(lhs).to eq(rhs)
        end

      end)
    end
  end

  

end