defmodule ESpec.DocTest do

  @agent_name :doc_test_agent

  defmacro doctest(module, opts \\ []) do
   
     
    quote do

      ESpec.DocExample.extract(unquote(module))
      |> Enum.with_index
      |> Enum.each(fn({ex, index}) -> 
        
        context = Enum.reverse(@context)
        @examples %ESpec.Example{ description: "description", module: __MODULE__, function: :"doc_#{index}",
                                  opts: [], file: __ENV__.file, line: __ENV__.line, context: context,
                                  shared: @shared}
        
        {lhs, _} = Code.eval_string(ex.lhs)
        {rhs, _} = Code.eval_string(ex.rhs)
        
        s = """
        def doc_#{index}(__) do 
          expect(#{lhs}).to eq(#{rhs})
        end  
        """
        Code.eval_string(s, [], __ENV__)
        # IO.inspect __MODULE__.info(:functions)
      end)
    end
  end


  



end