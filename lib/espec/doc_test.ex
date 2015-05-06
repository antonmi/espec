defmodule ESpec.DocTest do

  @agent_name :doc_test_agent

  defmacro doctest(module, opts \\ []) do
    quote do
      ESpec.DocExample.extract(unquote(module))
      |> Enum.with_index
      |> Enum.each(fn({ex, index}) -> 

        context = Enum.reverse(@context)
        {fun, arity} = ex.fun_arity

        description = "Doctest for #{unquote(module)}.#{fun}/#{arity} (#{index + 1})"
        function = :"#{ESpec.Support.word_chars(description)}_#{index}"

        @examples %ESpec.Example{ description: description, module: __MODULE__, function: function,
                                  opts: [], file: __ENV__.file, line: __ENV__.line, context: context,
                                  shared: false}

        {lhs, _} = Code.eval_string(ex.lhs)
        {rhs, _} = Code.eval_string(ex.rhs)

        s = """
        def #{function}(__) do
          expect(#{inspect lhs}).to eq(#{inspect rhs})
        end  
        """
        Code.eval_string(s, [], __ENV__)
      end)
    end
  end

end
