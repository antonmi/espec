defmodule Espec.Runner do

  require IEx

  def run(examples, module) do
    examples |> Enum.reverse
    |> Enum.each(fn(example) ->
      # IO.puts("Running \"#{Espec.Example.full_description(ex)}\"")
      bdata = run_befores(example, module)
      run_expamle(example, module, bdata)
    end)
  end

  defp run_expamle(example, module, bdata) do
    apply(module, example.function, [bdata])
  end

  defp run_befores(example, module) do
    res = extract_befores(example.context)
    |> Enum.map(fn(fuction) ->
      apply(module, fuction, [])
    end)
    fill_dict(%{}, res)
  end

  defp extract_befores(context) do
    context |>
    Enum.filter(fn(struct) ->
      struct.__struct__ == Espec.Before
    end)
    |> Enum.map(&(&1.function))
  end

  defp fill_dict(dict, res) do
    Enum.reduce(res, dict, fn(el, acc) ->
      IO.puts(inspect el)
      case el do
        {:ok, list} when is_list(list)-> Enum.reduce(list, acc, fn({k,v}, a) -> Dict.put(a, k, v) end)
        _ -> acc
      end
    end)
  end

end
