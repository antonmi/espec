defmodule ESpec.Formatter do
  @moduledoc """
    Functions to print espec results
  """

  @green IO.ANSI.green
  @red IO.ANSI.red
  @cyan IO.ANSI.cyan
  @reset IO.ANSI.reset

  @doc """
    Prints results
  """
  def print_result(examples) do
    unless silent? do
      failed = ESpec.Example.failed(examples)
      print_failed(failed)
      print_footer(examples, failed)
    end
  end

  def success(example) do
    unless silent?, do: IO.write("#{@green}.#{@reset}") 
  end

  def failed(example) do
    unless silent?, do: IO.write("#{@red}F#{@reset}")
  end

  defp print_failed(failed) do
    failed |> Enum.with_index
    |> Enum.each(&print_fail(&1))
  end

  defp print_fail({example, index}) do
    IO.puts("\n")
    to_print = [
      "\t#{index + 1}) #{ESpec.Example.full_description(example)}",
      "\t#{@cyan}#{example.file}:#{example.line}#{@reset}",
      "\t#{@red}#{example.error.message}#{@reset}",
    ] |> Enum.join("\n")
    IO.puts(to_print)
  end

  defp print_footer(examples, failed) do
    IO.puts "\n"
    color = if Enum.any?(failed), do: @red, else: @green
    IO.puts "\t#{color}#{Enum.count(examples)} examples, #{Enum.count(failed)} failures#{@reset}"
    IO.puts "\n"
  end

  defp silent?, do: ESpec.Configuration.get(:silent)

end
