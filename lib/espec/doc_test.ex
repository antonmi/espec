defmodule ESpec.DocTest do
  @moduledoc """
  Implements functionality similar to ExUnit.DocTest.
  Provides doctest macro.
  Read the ExUnit.DocTest documentation for more info.

  There are three types of specs:
  :test - examples where input and output can be evaluated:
    iex> Enum.map [1, 2, 3], fn(x) ->
    ...>   x * 2
    ...> end
    [2,4,6]
    Such examples will be converted to: 'expect(input).to eq(output)' assertion.

  :inspect - examples which return complex structure so Elixir prints it as #Name<...>.
    iex> Enum.into([a: 10, b: 20], HashDict.new)
    #HashDict<[b: 20, a: 10]>
    The examples will be converted to: 'expect(inspect input).to eq(output)'.

  :error - examples with exceptions:
    iex(1)> String.to_atom((fn() -> 1 end).())
    ** (ArgumentError) argument error
    The examples will be converted to: expect(fn -> input end).to raise_exception(error_module, error_message).
  """

  @doc "Parses the module and builds 'specs'."
  defmacro doctest(module, opts \\ []) do
    do_import = Keyword.get(opts, :import, false)
    quote do
      ESpec.DocTest.do_doctest(unquote(module), unquote(opts), unquote(do_import))
    end
  end

  @doc false
  defmacro do_doctest(module, opts, true) do
    quote do
      import unquote(module)
      ESpec.DocTest.create_doc_examples(unquote(module), unquote(opts))
    end
  end

  @doc false
  defmacro do_doctest(module, opts, false) do
    quote do
      ESpec.DocTest.create_doc_examples(unquote(module), unquote(opts))
    end
  end

  @doc false
  defmacro create_doc_examples(module, opts) do
    quote do
      examples = ESpec.DocExample.extract(unquote(module))

      if Keyword.get(unquote(opts), :only, :false) do
        examples = ESpec.DocTest.filter_only(examples, unquote(opts)[:only])
      end
      if Keyword.get(unquote(opts), :except, false) do
        examples = ESpec.DocTest.filter_except(examples, unquote(opts)[:except])
      end

      Enum.with_index(examples)
      |> Enum.reduce({[], {nil, nil}}, fn({ex, index}, {prev_binding, {binding_fun, binding_arity}}) ->
        context = Enum.reverse(@context)
        {fun, arity} = ex.fun_arity

        description = "Doctest for #{unquote(module)}.#{fun}/#{arity} (#{index})"
        function = :"#{ESpec.Support.word_chars(description)}_#{index}"

        @examples %ESpec.Example{ description: description, module: __MODULE__, function: function,
                                  opts: [], file: __ENV__.file, line: __ENV__.line, context: context,
                                  shared: false}

        binding = case {binding_fun, binding_arity} do
          {^fun, ^arity} -> prev_binding
          _ -> []
        end

        {string_to_eval, new_binding} =
          cond do
            ex.type == :test ->
              {lhs, new_binding} = Code.eval_string(ex.lhs, binding, __ENV__)
              {rhs, _} = Code.eval_string(ex.rhs, binding, __ENV__)
              str = """
              def #{function}(shared) do
                shared[:key]
                expect(#{inspect lhs}).to eq(#{inspect rhs})
              end
              """
              {str, new_binding}
            ex.type == :error ->
              {error_module, error_message} = ex.rhs
              lhs = ex.lhs
              str = """
              def #{function}(shared) do
                shared[:key]
                expect(fn -> Code.eval_string(#{lhs}) end).to raise_exception(#{error_module}, "#{error_message}")
              end
              """
              {str, binding}
            ex.type == :inspect ->
              {lhs, new_binding} = Code.eval_string(ex.lhs, binding, __ENV__)
              {rhs, _} = Code.eval_string(ex.rhs, binding, __ENV__)
              lhs = inspect(lhs)
              str = """
              def #{function}(shared) do
                shared[:key]
                expect(#{inspect lhs}).to eq(#{inspect rhs})
              end
              """
              {str, new_binding}
            true ->
              raise RuntimeError, message: "Wrong %ESpec.DocExample{} type!"
          end

        Code.eval_string(string_to_eval, [], __ENV__)
        {binding ++ new_binding, {fun, arity}}
      end)
    end
  end

  @doc false
  def filter_only(examples, list) do
    Enum.filter(examples, &Enum.member?(list, &1.fun_arity))
  end

  @doc false
  def filter_except(examples, list) do
    Enum.filter(examples, fn(ex) ->
      !Enum.member?(list, ex.fun_arity)
    end)
  end
end
