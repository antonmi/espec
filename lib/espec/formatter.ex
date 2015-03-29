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
    unless silent? do
      failed = ESpec.Example.failure(examples)
      if Enum.any?(failed), do: print_failed(failed)
      pending = ESpec.Example.pendings(examples)
      if Enum.any?(pending), do: print_pending(pending)
      print_footer(examples, failed, pending)
    end
  end

  def success(_example) do
    unless silent?, do: IO.write("#{@green}.#{@reset}") 
  end

  def failure(_example) do
    unless silent?, do: IO.write("#{@red}F#{@reset}")
  end

  def pending(_example) do
    unless silent?, do: IO.write("#{@yellow}*#{@reset}")
  end

  defp print_failed(failed) do
    failed |> Enum.with_index
    |> Enum.each(&print_fail(&1))
  end

  defp print_pending(failed) do
    failed |> Enum.with_index
    |> Enum.each(&print_pend(&1))
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

  defp print_pend({example, index}) do
    IO.puts("\n")
    to_print = [
      "\t#{index + 1}) #{ESpec.Example.full_description(example)}",
      "\t#{@cyan}#{example.file}:#{example.line}#{@reset}",
      "\t#{@yellow}#{example.result}#{@reset}",
    ] |> Enum.join("\n")
    IO.puts(to_print)
  end

  defp print_footer(examples, failed, pending) do
    IO.puts "\n"
    color = if Enum.any?(failed) do
      @red
    else
      if Enum.any?(pending), do: @yellow, else: @green
    end
    parts = ["#{Enum.count(examples)} examples", "#{Enum.count(failed)} failures"]
    if Enum.any?(pending), do: parts = parts ++ ["#{Enum.count(pending)} pending"]
    IO.puts "\t#{color}#{Enum.join(parts, ", ")}#{@reset}"
    IO.puts "\n"
  end

  defp silent?, do: ESpec.Configuration.get(:silent)

end
