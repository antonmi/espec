defmodule ESpec.Formatter do


  def print_result(examples) do
    failed = ESpec.Example.failed(examples)
    failed |> Enum.with_index
    |> Enum.each(&print_failed(&1))
  end

  def print_failed({example, index}) do
    IO.puts("\n")
    to_print = [
      "\t\e[37;1m#{index + 1}) #{example.description}\e[m",
      "\t\e[36;1m#{example.file}:#{example.line}\e[0m",
      "\t\e[31;1m#{example.error.message}\e[0m",
    ] |> Enum.join("\n")
    IO.puts(to_print)
  end

end
