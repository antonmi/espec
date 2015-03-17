defmodule ESpec.Runner do

  require IEx

  def run(examples, module) do
    examples
    |> Enum.each(fn(ex) ->
      IO.puts("Running \"#{ESpec.Example.full_description(ex)}\"")
      apply(module, ex.function, ex.opts)
    end)
  end

end
