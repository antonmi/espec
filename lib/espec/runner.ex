defmodule ESpec.Runner do

  require IEx

  def run(opts) do
    ESpec.specs |> Enum.reverse
    |> Enum.map(fn(module) ->
      filter(module.examples, opts)
      |> run_examples(module)
    end)
    |> List.flatten
  end

  def run_examples(examples, module) do
    examples
    |> Enum.map(fn(example) ->
      set_lets(example, module)
      assigns = run_befores(example, module)
      run_example(example, module, assigns)
    end)
  end

  defp run_example(example, module, assigns) do
    try do
      apply(module, example.function, [assigns])
      IO.write("\e[32;1m.\e[0m")
      %ESpec.Example{example | success: true}
    rescue
      error in [ESpec.AssertionError] ->
        IO.write("\e[31;1mF\e[0m")
        %ESpec.Example{example | success: false, error: error}
    end
  end

  defp run_befores(example, module) do
    res = extract_befores(example.context)
    |> Enum.map(fn(before) ->
      apply(module, before.function, [])
    end)
    fill_dict(%{}, res)
  end

  defp set_lets(example, module) do
    extract_lets(example.context)
    |> Enum.each(fn(let) ->
      ESpec.Let.let_agent_put({module, let.var}, apply(module, let.function, []))
    end)
  end

  defp extract_befores(context), do: extract(context, ESpec.Before)

  defp extract_lets(context), do: extract(context, ESpec.Let)

  defp extract(context, module) do
    context |>
    Enum.filter(fn(struct) ->
      struct.__struct__ == module
    end)
  end

  defp fill_dict(dict, res) do
    Enum.reduce(res, dict, fn(el, acc) ->
      case el do
        {:ok, list} when is_list(list)-> Enum.reduce(list, acc, fn({k,v}, a) -> Dict.put(a, k, v) end)
        _ -> acc
      end
    end)
  end

  defp filter(examples, opts) do
    file_opts = opts[:file_opts]
    examples |> Enum.filter(fn(example) ->
      opts = opts_for_file(example.file, file_opts)
      line = Keyword.get(opts, :line)
      if line, do: example.line == line, else: true
    end)
  end

  defp opts_for_file(file, opts_list) do
    case opts_list |> Enum.find(fn {k, _} -> k == file end) do
      {_file, opts} -> opts
      nil -> []
    end
  end

end
