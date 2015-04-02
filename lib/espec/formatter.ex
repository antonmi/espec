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

  @status_colors [success: @green, failure: @red, pending: @yellow]
  @status_symbols [success: ".", failure: "F", pending: "*"]

  @doc """
    Prints results
  """
  def print_result(examples) do
    unless silent? do
      pending = ESpec.Example.pendings(examples)
      if Enum.any?(pending), do: print_pending(pending)
      failed = ESpec.Example.failure(examples)
      if Enum.any?(failed), do: print_failed(failed)
      print_footer(examples, failed, pending)
    end
  end
  
  def example_info(example) do
    color = color_for_status(example.status)
    symbol = symbol_for_status(example.status)
    unless silent? do
      if trace? do
        IO.puts(trace_description(example))
      else
        IO.write("#{color}#{symbol}#{@reset}")
      end
    end
  end

  defp print_failed(failed) do
    failed |> Enum.with_index
    |> Enum.each fn({example, index}) -> 
      print_example(example, example.error.message, index)
    end
  end

  defp print_pending(pending) do
    pending |> Enum.with_index
    |> Enum.each fn({example, index}) -> 
      print_example(example, example.result, index)
    end
  end

  defp print_example(example, info, index) do
    color = color_for_status(example.status)
    decription = one_line_description(example)
    IO.puts("\n")
    to_print = [
      "\t#{index + 1}) #{decription}",
      "\t#{@cyan}#{example.file}:#{example.line}#{@reset}",
      "\t#{color}#{info}#{@reset}",
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

  defp one_line_description(example) do
    module = "#{example.module}" |> String.replace("Elixir.", "")
    [ module | ESpec.Example.context_descriptions(example)] ++ [example.description]
    |> Enum.join(" ")
  end

  defp trace_description(example) do
    color = color_for_status(example.status)
    module = "#{example.module}" |> String.replace("Elixir.", "")
    ex_desc = if String.length(example.description) > 0 do 
      "#{color}#{example.description}#{@reset}"
    else
      if example.status == :failure do
        "#{color}#{example.error.message}#{@reset}"
      else
        "#{color}#{example.result}#{@reset}"
      end
    end
    array = [ module | ESpec.Example.context_descriptions(example)] ++ [ex_desc]
    {result, _} = Enum.reduce(array, {"", ""}, fn(description, acc) ->
      {d, w} = acc
      {d <> w <> description <> "\n", w <> "  "}
    end) 
    result
  end

  defp color_for_status(status), do: Keyword.get(@status_colors, status)
  defp symbol_for_status(status), do: Keyword.get(@status_symbols, status)

  defp silent?, do: ESpec.Configuration.get(:silent)
  defp trace?, do: ESpec.Configuration.get(:trace)

end
