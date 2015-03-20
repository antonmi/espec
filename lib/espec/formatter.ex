defmodule ESpec.Formatter do


  def print_result(examples) do
    failed = ESpec.Example.failed(examples)
    print_failed(failed)
    print_footer(examples, failed)
  end

  defp print_failed(failed) do
    failed |> Enum.with_index
    |> Enum.each(&print_fail(&1))
  end

  defp print_fail({example, index}) do
    IO.puts("\n")
    to_print = [
      "\t\e[37;1m#{index + 1}) #{example.description}\e[m",
      "\t\e[36;1m#{example.file}:#{example.line}\e[0m",
      "\t\e[31;1m#{example.error.message}\e[0m",
    ] |> Enum.join("\n")
    IO.puts(to_print)
  end

  defp print_footer(examples, failed) do
    IO.puts "\n"
    color = if Enum.any?(failed), do: "\e[31;1m", else: "\e[37;1m"
    IO.puts "\t#{color}#{Enum.count(examples)} examples, #{Enum.count(failed)} failures\e[0m"
    IO.puts "\n"
  end

end
