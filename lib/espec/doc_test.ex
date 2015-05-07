defmodule ESpec.DocTest do

  defmacro doctest(module, opts \\ []) do
    do_import = Keyword.get(opts, :import, false)
    quote do
      do_doctest(unquote(module), unquote(opts), unquote(do_import))
    end
  end

  defmacro do_doctest(module, opts, true) do
    quote do
      import unquote(module)
      create_doc_examples(unquote(module), unquote(opts))
    end
  end

  defmacro do_doctest(module, opts, false) do
    quote do
      create_doc_examples(unquote(module), unquote(opts))
    end
  end

  defmacro create_doc_examples(module, opts) do
    quote do
      examples = ESpec.DocExample.extract(unquote(module))
      if Keyword.get(unquote(opts), :only, :false) do
        examples = unquote(__MODULE__).filter_only(examples, unquote(opts)[:only])
      end
      if Keyword.get(unquote(opts), :except, false) do
        examples = unquote(__MODULE__).filter_except(examples, unquote(opts)[:except]) 
      end 

      Enum.with_index(examples)
      |> Enum.each(fn({ex, index}) -> 

        context = Enum.reverse(@context)
        {fun, arity} = ex.fun_arity

        description = "Doctest for #{unquote(module)}.#{fun}/#{arity} (#{index})"
        function = :"#{ESpec.Support.word_chars(description)}_#{index}"

        @examples %ESpec.Example{ description: description, module: __MODULE__, function: function,
                                  opts: [], file: __ENV__.file, line: __ENV__.line, context: context,
                                  shared: false}

        {lhs, _} = Code.eval_string(ex.lhs, [], __ENV__)
        {rhs, _} = Code.eval_string(ex.rhs, [], __ENV__)

        s = """
        def #{function}(__) do
          expect(#{inspect lhs}).to eq(#{inspect rhs})
        end  
        """
        Code.eval_string(s, [], __ENV__)
      end)
    end
  end

  def filter_only(examples, list) do
    Enum.filter(examples, fn(ex) ->
      Enum.member?(list, ex.fun_arity)
    end)
  end

  def filter_except(examples, list) do
    Enum.filter(examples, fn(ex) ->
      !Enum.member?(list, ex.fun_arity)
    end)
  end
end
