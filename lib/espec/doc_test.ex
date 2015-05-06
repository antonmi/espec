defmodule ESpec.DocTest do

  @agent_name :doc_test_agent

  defmacro doctest(module, opts \\ []) do
   
     
    quote do

      ESpec.DocExample.extract(unquote(module))
      |> Enum.with_index
      |> Enum.each(fn({ex, index}) -> 

        context = Enum.reverse(@context)

        {fun, arity} = ex.fun_arity
        description = "Doctest for #{unquote(module)}.#{fun}/#{arity} (#{index})"
        function = :"#{ESpec.Support.word_chars(description)}_#{index}"

        @examples %ESpec.Example{ description: description, module: __MODULE__, function: function,
                                  opts: [], file: __ENV__.file, line: __ENV__.line, context: context,
                                  shared: @shared}
        IO.inspect "-----"
        IO.inspect length(@examples)

       


        s = """
        def #{function}(__) do
          expect(#{inspect ex.lhs}).to eq(#{inspect ex.rhs})
        end  
        """
        Code.eval_string(s, [], __ENV__)
      end)
    end
  end


  



end
