defmodule ESpec.Formatters.Doc do
  @moduledoc """
  Generates plain colored text output.
  """
  @green IO.ANSI.green()
  @red IO.ANSI.red()
  @cyan IO.ANSI.cyan()
  @yellow IO.ANSI.yellow()
  # @grey IO.ANSI.light_black()
  @reset IO.ANSI.reset()

  @main_colors [stacktrace: @cyan, diff_headers: @cyan]
  @status_colors [success: @green, failure: @red, pending: @yellow]
  @status_symbols [success: ".", failure: "F", pending: "*"]
  @diff_colors [
    diff_delete: :red,
    diff_delete_whitespace: IO.ANSI.color_background(2, 0, 0),
    diff_insert: :green,
    diff_insert_whitespace: IO.ANSI.color_background(0, 2, 0)
  ]

  alias ESpec.Example

  use ESpec.Formatters.Base

  @doc "Formats an example result."
  def format_example(example, opts) do
    color = color_for_status(example.status)
    symbol = symbol_for_status(example.status)

    if opts[:details] do
      trace_description(example)
    else
      colorize(color, symbol)
    end
  end

  @doc "Formats the final result."
  def format_result(examples, durations, opts) do
    pending = Example.pendings(examples)
    string = ""
    string = if Enum.any?(pending), do: string <> format_pending(pending), else: string
    failed = Example.failure(examples)
    string = if Enum.any?(failed), do: string <> format_failed(failed, opts), else: string
    string = string <> format_footer(examples, failed, pending)
    string = string <> format_times(durations, failed, pending)
    string <> format_seed()
  end

  defp format_failed(failed, opts) do
    failed
    |> Enum.with_index()
    |> Enum.map_join("\n", fn {example, index} ->
      do_format_failed_example(example, index, opts)
    end)
  end

  defp format_pending(pending) do
    pending
    |> Enum.with_index()
    |> Enum.map_join("\n", fn {example, index} ->
      do_format_pending_example(example, example.result, index)
    end)
  end

  defp do_format_pending_example(example, info, index) do
    color = color_for_status(example.status)
    description = one_line_description(example)
    file_line_ref = "#{example.file}:#{example.line}"

    [
      "\n",
      "\t#{index + 1}) #{description}",
      "\t#{colorize(@main_colors[:stacktrace], file_line_ref)}",
      "\t#{colorize(color, info)}"
    ]
    |> Enum.join("\n")
  end

  defp do_format_failed_example(example, index, opts) do
    color = color_for_status(example.status)
    description = one_line_description(example)

    error_message =
      example.error.message
      |> String.replace("\n", "\n\t  ")

    stacktrace = do_format_stacktrace(example)

    Enum.join(
      [
        "\n",
        "\t#{index + 1}) #{description}",
        "\t#{colorize(@main_colors[:stacktrace], stacktrace)}",
        "\t#{colorize(color, error_message)}"
      ],
      "\n"
    ) <> if Map.get(opts, :diff_enabled?, true), do: do_format_diff(example.error), else: ""
  end

  defp do_format_stacktrace(example) do
    list =
      example
      |> do_format_stacktrace_list()
      |> Enum.reverse()

    line = "#{Path.relative_to_cwd(example.file)}:#{example.line}"

    if Enum.empty?(list) do
      line
    else
      ["#{line}: (example)" | list]
      |> Enum.reverse()
      |> Enum.join("\n\t")
    end
  end

  defp do_format_stacktrace_list(example) do
    if is_nil(example.error.stacktrace) do
      []
    else
      example.error.stacktrace
      |> remove_example_if_first(example)
      |> Enum.map(fn {module, function, arity, [file: file, line: line]} = item ->
        if in_this_example?(example, item) do
          "#{file}:#{line}: (inside example)"
        else
          "#{file}:#{line}: #{module}.#{function}/#{arity}"
        end
      end)
    end
  end

  defp in_this_example?(example, {module, function, arity, [file: file, line: _line]}) do
    module == example.module && function == example.function && arity == 1 &&
      file == String.to_charlist(Path.relative_to_cwd(example.file))
  end

  defp remove_example_if_first([], _example) do
    []
  end

  defp remove_example_if_first([{_, _, _, [file: _, line: line]} = first | rest] = trace, example) do
    if in_this_example?(example, first) && line == example.line do
      rest
    else
      trace
    end
  end

  defp do_format_diff(%ESpec.AssertionError{extra: %{diff_fn: f}}) when is_function(f, 0) do
    format_diff(f.())
  end

  defp do_format_diff(_), do: ""

  defp colorize(ansi_color_code, string) do
    [ansi_color_code, string, @reset]
    |> IO.ANSI.format_fragment(true)
    |> IO.iodata_to_binary()
  end

  defp format_diff(nil) do
    ""
  end

  if Version.match?(System.version(), ">= 1.10.0") do
    defp format_diff(%ExUnit.Diff{
           left: left,
           right: right
         }) do
      left =
        left
        |> ExUnit.Diff.to_algebra(fn doc ->
          Inspect.Algebra.color(
            doc,
            get_color_by_content(doc, :diff_delete, :diff_delete_whitespace),
            %Inspect.Opts{syntax_colors: @diff_colors}
          )
        end)
        |> Inspect.Algebra.nest(20)
        |> Inspect.Algebra.format(80)

      right =
        right
        |> ExUnit.Diff.to_algebra(fn doc ->
          Inspect.Algebra.color(
            doc,
            get_color_by_content(doc, :diff_insert, :diff_insert_whitespace),
            %Inspect.Opts{syntax_colors: @diff_colors}
          )
        end)
        |> Inspect.Algebra.nest(20)
        |> Inspect.Algebra.format(80)

      "\n\t  #{colorize(@main_colors[:diff_headers], "expected:")} " <>
        IO.iodata_to_binary(left) <>
        "\n\t  #{colorize(@main_colors[:diff_headers], "actual:")}   " <>
        IO.iodata_to_binary(right)
    end

    defp get_color_by_content(content, color_if_normal, color_if_whitespace)
         when is_binary(content) do
      if String.trim_leading(content) == "", do: color_if_whitespace, else: color_if_normal
    end

    defp get_color_by_content(_content, color_if_normal, _color_if_whitespace) do
      color_if_normal
    end
  else
    defp format_diff({l, r}) do
      [
        "",
        "\t  #{colorize(@main_colors[:diff_headers], "expected:")} #{colorize_diff(r)}",
        "\t  #{colorize(@main_colors[:diff_headers], "actual:")}   #{colorize_diff(l)}"
      ]
      |> Enum.join("\n")
    end

    defp colorize_diff([{:eq, text} | rest]) do
      text <> colorize_diff(rest)
    end

    defp colorize_diff([{:ins, text} | rest]) do
      colorize(@diff_colors[:diff_insert], text) <> colorize_diff(rest)
    end

    defp colorize_diff([{:del, text} | rest]) do
      colorize(@diff_colors[:diff_delete], text) <> colorize_diff(rest)
    end

    defp colorize_diff([{:ins_whitespace, length} | rest]) do
      colorize(@diff_colors[:diff_insert_whitespace], String.duplicate(" ", length)) <>
        colorize_diff(rest)
    end

    defp colorize_diff([]) do
      ""
    end
  end

  defp format_footer(examples, failed, pending) do
    color = get_color_for_content(failed, pending)
    parts = ["#{Enum.count(examples)} examples", "#{Enum.count(failed)} failures"]
    parts = if Enum.any?(pending), do: parts ++ ["#{Enum.count(pending)} pending"], else: parts
    parts_string = Enum.join(parts, ", ")

    "\n\n\t#{colorize(color, parts_string)}"
  end

  defp format_times({start_loading_time, finish_loading_time, finish_specs_time}, failed, pending) do
    color = get_color_for_content(failed, pending)
    load_time = :timer.now_diff(finish_loading_time, start_loading_time)
    spec_time = :timer.now_diff(finish_specs_time, finish_loading_time)

    finished_in =
      "Finished in #{us_to_sec(load_time + spec_time)} seconds" <>
        " (#{us_to_sec(load_time)}s on load, #{us_to_sec(spec_time)}s on specs)"

    "\n\n\t#{colorize(color, finished_in)}\n\n"
  end

  defp format_seed do
    if ESpec.Configuration.get(:order) do
      ""
    else
      seed = ESpec.Configuration.get(:seed)
      "\tRandomized with seed #{seed}\n\n"
    end
  end

  defp us_to_sec(us), do: div(us, 10_000) / 100

  defp get_color_for_content(failed, pending) do
    if Enum.any?(failed) do
      @status_colors[:failure]
    else
      if Enum.any?(pending), do: @status_colors[:pending], else: @status_colors[:success]
    end
  end

  defp one_line_description(example) do
    desc = Example.context_descriptions(example) ++ [example.description]

    desc
    |> Enum.join(" ")
    |> String.trim_trailing()
  end

  defp trace_description(example) do
    color = color_for_status(example.status)

    ex_desc =
      if String.length(example.description) > 0 do
        "#{colorize(color, example.description)}"
      else
        status_message(example, color)
      end

    array = Example.context_descriptions(example) ++ [ex_desc]

    {result, _} =
      Enum.reduce(array, {"", ""}, fn description, acc ->
        {d, w} = acc
        {d <> w <> "#{description}" <> "\n", w <> "  "}
      end)

    result
  end

  defp status_message(example, color) do
    if example.status == :failure do
      "#{colorize(color, example.error.message)}"
    else
      "#{colorize(color, inspect(example.result))}"
    end
  end

  defp color_for_status(status), do: Keyword.get(@status_colors, status)
  defp symbol_for_status(status), do: Keyword.get(@status_symbols, status)
end
