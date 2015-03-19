defmodule ESpec.Runner do

  require IEx

  def run(opts \\ []) do
    ESpec.specs |> Enum.reverse
    |> Enum.map(fn(module) ->
      run_examples(module.examples, module)
    end)
  end

  def run_examples(examples, module) do
    examples |> Enum.reverse
    |> Enum.map(fn(example) ->
      # IO.puts("Running \"#{ESpec.Example.full_description(ex)}\"")
      assigns = run_befores(example, module)
      run_expamle(example, module, assigns)
    end)
  end

  defp run_expamle(example, module, assigns) do
    result = apply(module, example.function, [assigns])
    %ESpec.ExampleResult{example: example, result: result}
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
      struct.__struct__ == ESpec.Before
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
