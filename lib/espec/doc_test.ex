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
      ESpec.DocTest.__do_doctest__(unquote(module), unquote(opts), unquote(do_import))
    end
  end

  @doc false
  defmacro __do_doctest__(module, opts, true) do
    quote do
      import unquote(module)
      ESpec.DocTest.__create_doc_examples__(unquote(module), unquote(opts))
    end
  end

  defmacro __do_doctest__(module, opts, false) do
    quote do
      ESpec.DocTest.__create_doc_examples__(unquote(module), unquote(opts))
    end
  end

  @doc false
  defmacro __create_doc_examples__(module, opts) do
    quote do
      examples = ESpec.DocExample.extract(unquote(module))

      examples = if Keyword.get(unquote(opts), :only, :false) do
        ESpec.DocTest.__filter_only__(examples, unquote(opts)[:only])
      else
        examples
      end
      examples = if Keyword.get(unquote(opts), :except, false) do
        ESpec.DocTest.__filter_except__(examples, unquote(opts)[:except])
      else
        examples
      end

      Enum.with_index(examples)
      |> Enum.reduce({[], {nil, nil}}, fn({ex, index}, {prev_binding, {binding_fun, binding_arity}}) ->
        context = Enum.reverse(@context)
        {fun, arity} = ex.fun_arity

        description = "Doctest for #{unquote(module)}.#{fun}/#{arity} (#{index})"
        function = :"#{ESpec.Support.word_chars(description)}_#{index}"

        @examples %ESpec.Example{description: description, module: __MODULE__, function: function,
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
                expect(fn -> Code.eval_string(#{lhs}) end).to raise_exception(#{error_module}, #{inspect error_message})
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
  def __filter_only__(examples, list) do
    Enum.filter(examples, &Enum.member?(list, &1.fun_arity))
  end

  @doc false
  def __filter_except__(examples, list) do
    Enum.filter(examples, fn(ex) ->
      !Enum.member?(list, ex.fun_arity)
    end)
  end
end
