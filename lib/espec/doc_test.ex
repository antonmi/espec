defmodule ESpec.DocTest do


  defmacro doctest(module, opts \\ []) do
    {mod, _} = Code.eval_quoted module
    ESpec.DocExample.extract(mod)
    |> Enum.each(fn(ex) -> 
      IO.inspect ex
      quote do
        unquote(__MODULE__).example "Doc test" do
             IO.inspect "adadas"
              # expect(ex.lhs).to eq(3)
             # end
        end
      end
    end)
    # quote do
    #   # IO.inspect unquote(module)
    #   ESpec.DocExample.extract(unquote(module))
    #   |> Enum.each(fn(ex) -> 
    #     # block = quote do
          
    #     # end
    #     l = Macro.escape(ex.lhs)
    #     IO.inspect l
        
    #     # ESpec.Example.example(unquote( "Doc test"), [], do: 1+1)
    #     ESpec.Example.example "Doc test" do
    #        # quote do
    #         # IO.inspect unquote(ex)
    #         # expect(ex.lhs).to eq(3)
    #        # end
    #     end
      

    #   end)
    # end
  end


  

end