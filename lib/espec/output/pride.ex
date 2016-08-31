defmodule ESpec.Output.Pride do
  @moduledoc """
  Generates plain colored text output.
  """
  @red IO.ANSI.red
  @cyan IO.ANSI.cyan
  @yellow IO.ANSI.yellow
  @reset IO.ANSI.reset

  @status_colors [failure: @red, pending: @yellow]
  @status_symbols [success: ".", failure: "F", pending: "*"]

  alias ESpec.Example

  @doc "Formats the final result."
  def format_result(examples, times, _opts) do
    pending = Example.pendings(examples)
    string = ""
    string = if Enum.any?(pending), do: string <> format_pending(pending), else: string
    failed = Example.failure(examples)
    string = if Enum.any?(failed), do: string <> format_failed(failed), else: string
    string = string <> format_footer(examples, failed, pending)
    string = string <> format_times(times, failed, pending)
    Agent.stop(:color_index)
    string <> format_seed
  end

  @doc "Formats an example result."
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
    |> Enum.map(fn({example, index}) ->
      do_format_example(example, example.error.message, index)
    end)
    Enum.join(res, "\n")
  end

  defp format_pending(pending) do
    res = pending |> Enum.with_index
    |> Enum.map(fn({example, index}) ->
      do_format_example(example, example.result, index)
    end)
    Enum.join(res, "\n")
  end

  defp do_format_example(example, info, index) do
    color = color_for_status(example.status)
    description = one_line_description(example)
    [
      "\n",
      "\t#{index + 1}) #{description}",
      "\t#{@cyan}#{example.file}:#{example.line}#{@reset}",
      "\t#{color}#{info}#{@reset}",
    ]
    |> Enum.join("\n")
  end

  defp format_footer(examples, failed, pending) do
    color = get_color(failed, pending)
    parts = ["#{Enum.count(examples)} examples", "#{Enum.count(failed)} failures"]
    parts = if Enum.any?(pending), do: parts ++ ["#{Enum.count(pending)} pending"], else: parts
    "\n\n\t#{color}#{Enum.join(parts, ", ")}#{@reset}"
  end

  defp format_times({start_loading_time, finish_loading_time, finish_specs_time}, failed, pending) do
    color = get_color(failed, pending)
    load_time = :timer.now_diff(finish_loading_time, start_loading_time)
    spec_time = :timer.now_diff(finish_specs_time, finish_loading_time)
    "\n\n\t#{color}Finished in #{us_to_sec(load_time + spec_time)} seconds"
    <> " (#{us_to_sec(load_time)}s on load, #{us_to_sec(spec_time)}s on specs)#{@reset}\n\n"
  end

  defp format_seed do
    if ESpec.Configuration.get(:order) do
      ""
    else
      seed = ESpec.Configuration.get(:seed)
      "\tRandomized with seed #{seed}\n\n"
    end
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
    [ module | Example.context_descriptions(example)] ++ [example.description]
    |> Enum.join(" ") |> String.rstrip
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
    array = Example.context_descriptions(example) ++ [ex_desc]
    {result, _} = Enum.reduce(array, {"", ""}, fn(description, acc) ->
      {d, w} = acc
      {d <> w <> "#{description}" <> "\n", w <> "  "}
    end)
    result
  end

  defp color_for_status(:success), do: next_color_for_success
  defp color_for_status(status), do: Keyword.get(@status_colors, status)
  defp symbol_for_status(status), do: Keyword.get(@status_symbols, status)

  defp next_color_for_success do
    agent = get_color_index_agent
    index = Agent.get(agent, &(&1))
    {r, g, b} = Enum.at(colors, rem(index, length(colors)))
    Agent.update(agent, &(&1 + 1))
    IO.ANSI.color(r, g, b)
  end

  # {r, g, b}
  defp colors do
    [
      {5,0,0}, {5,1,0}, {5,2,0}, {5,3,0}, {5,4,0},
      {5,5,0}, {4,5,0}, {3,5,0}, {2,5,0}, {1,5,0},
      {0,5,0}, {0,5,1}, {0,5,2}, {0,5,3}, {0,5,4},
      {0,5,5}, {0,4,5}, {0,3,5}, {0,2,5}, {0,1,5},
      {0,0,5}, {1,0,5}, {2,0,5}, {3,0,5}, {4,0,5},
      {5,0,5}, {5,0,4}, {5,0,3}, {5,0,2}, {5,0,1}
    ]
  end

  defp get_color_index_agent do
    case Agent.start(fn -> 0 end, name: :color_index) do
      {:ok, agent} -> agent
      {:error, {:already_started, agent}} -> agent
    end
  end
end
