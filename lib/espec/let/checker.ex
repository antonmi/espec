defmodule ESpec.Let.Checker do
  def check(context, defined_lets, escaped_block) do
    context_lets = context
    |> ESpec.Example.extract(ESpec.Let)
    |> Enum.map(&(&1.var))

    funcs = ESpec.Let.AstParser.function_list(escaped_block)

    diff = Enum.uniq(defined_lets) -- context_lets
    |> Enum.map(&("#{&1}/0"))

    if Enum.member?(funcs, "should/1") || Enum.member?(funcs, "is_expected/0") do
      funcs = ["subject/0" | funcs]
    end


    leaking_func = Enum.find(diff, &(Enum.member?(funcs, &1)))

    case leaking_func do
      "subject/0" ->
        raise "The subject is not defined in the current scope!"
      string when is_binary(string) ->
        raise "The let function `#{leaking_func}` is not defined in the current scope!"
      nil -> :ok
    end
  end
end
