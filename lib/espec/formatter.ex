defmodule ESpec.Formatter do
  @moduledoc """
    Functions to print espec results
  """

  @green IO.ANSI.green
  @red IO.ANSI.red
  @cyan IO.ANSI.cyan
  @yellow IO.ANSI.yellow
  @blue IO.ANSI.blue
  @reset IO.ANSI.reset

  @doc """
    Prints results
  """
  def print_result(examples) do
    IO.inspect examples
    unless silent? do
      failed = ESpec.Example.failure(examples)
      if Enum.any?(failed), do: print_failed(failed)
      skipped = ESpec.Example.skipped(examples)
      if Enum.any?(skipped), do: print_skipped(skipped)
      print_footer(examples, failed, skipped)
    end
  end

  def success(_example) do
    unless silent?, do: IO.write("#{@green}.#{@reset}") 
  end

  def failure(_example) do
    unless silent?, do: IO.write("#{@red}F#{@reset}")
  end

  defp print_failed(failed) do
    failed |> Enum.with_index
    |> Enum.each(&print_fail(&1))
  end

  defp print_skipped(failed) do
    failed |> Enum.with_index
    |> Enum.each(&print_skip(&1))
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

  defp print_skip({example, index}) do
    IO.puts("\n")
    to_print = [
      "\t#{index + 1}) #{ESpec.Example.full_description(example)}",
      "\t#{@cyan}#{example.file}:#{example.line}#{@reset}",
      "\t#{@blue}Temporarily skipped#{@reset}",
    ] |> Enum.join("\n")
    IO.puts(to_print)
  end

  defp print_footer(examples, failed, skipped) do
    IO.puts "\n"
    color = if Enum.any?(failed), do: @red, else: @green
    parts = ["#{Enum.count(examples)} examples", "#{Enum.count(failed)} failures"]
    if Enum.any?(skipped), do: parts = parts ++ ["#{Enum.count(skipped)} skipped examples"]
    IO.puts "\t#{color}#{Enum.join(parts, ", ")}#{@reset}"
    IO.puts "\n"
  end

  defp silent?, do: ESpec.Configuration.get(:silent)

end
