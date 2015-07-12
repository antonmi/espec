defmodule ESpec.Output.Doc do
  @moduledoc """
  Generate plain colored text output.
  """
  @green IO.ANSI.green
  @red IO.ANSI.red
  @cyan IO.ANSI.cyan
  @yellow IO.ANSI.yellow
  @blue IO.ANSI.blue
  @reset IO.ANSI.reset

  @status_colors [success: @green, failure: @red, pending: @yellow]
  @status_symbols [success: ".", failure: "F", pending: "*"]

  @doc "Format the final result."
  def format_result(examples, times, _opts) do
    pending = ESpec.Example.pendings(examples)
    string = ""
    if Enum.any?(pending), do: string = string <> format_pending(pending)
    failed = ESpec.Example.failure(examples)
    if Enum.any?(failed), do: string = string <> format_failed(failed)
    string = string <> format_footer(examples, failed, pending)
    string <> format_times(times, failed, pending)
  end
  
  @doc "Format an example result."
  def format_example(example, opts) do
    color = color_for_status(example.status)
    symbol = symbol_for_status(example.status)
    if opts[:details] do
      trace_description(example)
    else
      "#{color}#{symbol}#{@reset}"
    end
  end

  defp format_failed(failed) do
    res = failed |> Enum.with_index
    |> Enum.map fn({example, index}) -> 
      format_example(example, example.error.message, index)
    end
    Enum.join(res, "\n")
  end

  defp format_pending(pending) do
    res = pending |> Enum.with_index
    |> Enum.map fn({example, index}) -> 
      format_example(example, example.result, index)
    end
    Enum.join(res, "\n")
  end

  defp format_example(example, info, index) do
    color = color_for_status(example.status)
    decription = one_line_description(example)
    [
      "\n",
      "\t#{index + 1}) #{decription}",
      "\t#{@cyan}#{example.file}:#{example.line}#{@reset}",
      "\t#{color}#{info}#{@reset}",
    ]
    |> Enum.join("\n")
  end

  defp format_footer(examples, failed, pending) do
    color = get_color(failed, pending)
    parts = ["#{Enum.count(examples)} examples", "#{Enum.count(failed)} failures"]
    if Enum.any?(pending), do: parts = parts ++ ["#{Enum.count(pending)} pending"]
    "\n\n\t#{color}#{Enum.join(parts, ", ")}#{@reset}"
  end

  defp format_times({start_loading_time, finish_loading_time, finish_specs_time}, failed, pending) do
    color = get_color(failed, pending)
    load_time = :timer.now_diff(finish_loading_time, start_loading_time)
    spec_time = :timer.now_diff(finish_specs_time, finish_loading_time)
    "\n\n\t#{color}Finished in #{us_to_sec(load_time + spec_time)} seconds"
    <> " (#{us_to_sec(load_time)}s on load, #{us_to_sec(spec_time)}s on specs)#{@reset}\n\n"
  end

  defp us_to_sec(us), do: div(us, 10000) / 100

  defp get_color(failed, pending) do
    if Enum.any?(failed) do
      @red
    else
      if Enum.any?(pending), do: @yellow, else: @green
    end
  end

  defp one_line_description(example) do
    module = "#{example.module}" |> String.replace("Elixir.", "")
    [ module | ESpec.Example.context_descriptions(example)] ++ [example.description]
    |> Enum.join(" ")
  end

  defp trace_description(example) do
    color = color_for_status(example.status)
    ex_desc = if String.length(example.description) > 0 do 
      "#{color}#{example.description}#{@reset}"
    else
      if example.status == :failure do
        "#{color}#{example.error.message}#{@reset}"
      else
        "#{color}#{inspect example.result}#{@reset}"
      end
    end
    array = ESpec.Example.context_descriptions(example) ++ [ex_desc]
    {result, _} = Enum.reduce(array, {"", ""}, fn(description, acc) ->
      {d, w} = acc
      {d <> w <> "#{description}" <> "\n", w <> "  "}
    end) 
    result
  end

  defp color_for_status(status), do: Keyword.get(@status_colors, status)
  defp symbol_for_status(status), do: Keyword.get(@status_symbols, status)
end
