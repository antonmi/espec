defmodule ESpec.Let.QuoteAnalyzer do
  def function_list(ast) do
    {funcs, assigments} = Enum.partition(parse(ast, []), fn {key, value} -> key == :fun end)
    Enum.uniq(Keyword.values(funcs) -- Keyword.values(assigments))
  end

  defp parse({:|>, _, [ast_left, {ast, context, args}]}, fun_list) do
    parse({ast, context, [ast_left | args]}, fun_list)
  end

  defp parse({{:., [], [{:__aliases__, [alias: false], [module]}, fun]}, [], args}, fun_list) do
    [func_desc(module, fun, args) | fun_list ++ parse_args(args)]
  end

  defp parse({:=, _, [{assignment, _, _}, _value]}, fun_list) do
    [{:=, "#{assignment}/0"} | fun_list]
  end

  defp parse({fun, [], args}, fun_list) when fun in [:fn, :->, :__block__, :__aliases__] do
    fun_list ++ parse_args(args)
  end

  defp parse({fun, _, _}, fun_list) when fun in [:defmodule, :def, :defmacro] do
    fun_list
  end

  defp parse({fun, context, args}, fun_list) when is_atom(fun) and is_list(context) do
    module = Keyword.get(context, :context)
    [func_desc(module, fun, args) | fun_list ++ parse_args(args)]
  end

  defp parse({ast, _, args}, fun_list) when is_tuple(ast) do
    fun_list ++ parse(ast, []) ++ parse_args(args)
  end

  defp parse([do: ast], fun_list), do: parse(ast, []) ++ fun_list
  defp parse(_, fun_list), do: fun_list

  defp parse_args(args) when is_list(args) do
    Enum.reduce(args, [], &(parse(&1, []) ++ &2))
  end
  defp parse_args(_), do: []

  defp func_desc(module, fun, args) do
    arity = if is_list(args), do: length(args), else: 0
    desc = if module, do: "#{module}.#{fun}/#{arity}", else: "#{fun}/#{arity}"
    {:fun, desc}
  end
end
