defmodule ESpec.Runner do

  require IEx

  def run(examples, module) do
    examples |> Enum.reverse
    |> Enum.each(fn(example) ->
      # IO.puts("Running \"#{ESpec.Example.full_description(ex)}\"")
      run_befores(example, module)
      run_expamle(example, module)
    end)
  end

  defp run_expamle(example, module) do
    apply(module, example.function, example.opts)
  end

  defp run_befores(example, module) do
    extract_befores(example.context)
    |> Enum.each(fn(fuction) ->
      apply(module, fuction, [])
    end)
  end

  defp extract_befores(context) do
    context |>
    Enum.filter(fn(struct) ->
      struct.__struct__ == ESpec.Before
    end)
    |> Enum.map(&(&1.function))
  end

end
