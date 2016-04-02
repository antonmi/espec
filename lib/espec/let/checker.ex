defmodule ESpec.Let.Checker do
  def check(context, defined_lets, escaped_block) do
    context_lets = context_lets(context)

    diff = Enum.uniq(defined_lets) -- context_lets
    |> Enum.map(&("#{&1}/0"))

    functions = all_functions(escaped_block)
    leaking_func = Enum.find(diff, &(Enum.member?(functions, &1)))

    if leaking_func, do: raise ESpec.LetError, exception_message(leaking_func)
  end

  defp context_lets(context) do
    context
    |> ESpec.Example.extract(ESpec.Let)
    |> Enum.map(&(&1.var))
  end

  def all_functions(escaped_block) do
    funs = ESpec.Let.QuoteAnalyzer.function_list(escaped_block)
    if Enum.member?(funs, "should/1") || Enum.member?(funs, "is_expected/0") do
      funs = ["subject/0" | funs]
    end
    funs
  end

  defp exception_message(leaking_func) do
    if leaking_func == "subject/0" do
      "The subject is not defined in the current scope!"
    else
      "The let function `#{leaking_func}` is not defined in the current scope!"
    end
  end
end
