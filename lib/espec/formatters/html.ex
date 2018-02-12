defmodule ESpec.Formatters.Html do
  @moduledoc """
  Generates html output.
  """
  alias ESpec.Example

  use ESpec.Formatters.Base

  @doc "Format the final result."
  def format_result(examples, durations, _opts) do
    tree = context_tree(examples)
    html = make_html(tree, true)
    summary = format_summary(examples, durations)
    string = EEx.eval_file(template_path(), examples: html, summary: summary)
    String.replace(string, "\n", "")
  end

  @doc "Formats an example result."
  def format_example(_example, _opts), do: ""

  defp template_path, do: Path.join(Path.dirname(__ENV__.file), "templates/html.html.eex")

  defp context_tree(examples) do
    examples
    |> Enum.reduce({Map.new(), []}, fn ex, acc ->
      contexts = Example.extract_contexts(ex)
      put_deep(acc, contexts, ex)
    end)
  end

  defp put_deep({dict, values}, [el | tl], value) when length(tl) > 0 do
    d =
      case Map.get(dict, el) do
        {inner, vals} -> put_deep({inner, vals}, tl, value)
        nil -> put_deep({Map.new(), []}, tl, value)
      end

    {Map.put(dict, el, d), values}
  end

  defp put_deep({dict, values}, [el], value) do
    new_dict =
      case Map.get(dict, el) do
        {inner, vals} -> Map.put(dict, el, {inner, [value | vals]})
        nil -> Map.put(dict, el, {Map.new(), [value]})
      end

    {new_dict, values}
  end

  defp put_deep({dict, values}, [], value) do
    {dict, [value | values]}
  end

  defp make_html({dict, values}, top? \\ false, firstli? \\ false) do
    values
    |> main_lis
    |> ul_or_lis(firstli?)
    |> uls(dict, top?, firstli?)
  end

  defp main_lis(values) do
    Enum.reduce(values, "", fn ex, acc ->
      acc <> "<li class='#{li_class(ex)}'>#{ex_desc(ex)}</li>"
    end)
  end

  defp ul_or_lis(lis, firstli?) do
    if String.length(lis) > 0 do
      if firstli?, do: "<ul class='tree'>" <> lis <> "</ul>", else: "<ul>" <> lis <> "</ul>"
    else
      lis
    end
  end

  defp uls(lis, dict, top?, firstli?) do
    Enum.reduce(dict, lis, fn {key, d}, acc ->
      if top? do
        acc <>
          "<section class='context'><h3>#{key.description}</h3>" <>
          make_html(d, false, true) <> "</section>"
      else
        mainli = "<li><h4>#{key.description}</h4>"

        if firstli? do
          acc <> "<ul class='tree'>#{mainli}" <> make_html(d) <> "</li></ul>"
        else
          acc <> "<ul>#{mainli}" <> make_html(d) <> "</li></ul>"
        end
      end
    end)
  end

  defp ex_desc(ex) do
    res =
      if String.length(ex.description) > 0 do
        ex.description
      else
        if ex.status == :failure do
          ex.error.message |> String.replace("\n", "<br>")
        else
          ex.result
        end
      end

    res = "#{res} (#{ex.duration} ms)"
    String.replace(res, "\"", "'")
  end

  defp li_class(ex), do: ex.status

  defp format_summary(examples, {start_loading_time, finish_loading_time, finish_specs_time}) do
    pending = Example.pendings(examples)
    failed = Example.failure(examples)
    load_time = :timer.now_diff(finish_loading_time, start_loading_time)
    spec_time = :timer.now_diff(finish_specs_time, finish_loading_time)
    seed = get_seed()

    {
      Enum.count(examples),
      Enum.count(failed),
      Enum.count(pending),
      us_to_sec(load_time + spec_time),
      us_to_sec(load_time),
      us_to_sec(spec_time),
      seed
    }
  end

  defp us_to_sec(us), do: div(us, 10_000) / 100

  defp get_seed do
    if ESpec.Configuration.get(:order) do
      false
    else
      ESpec.Configuration.get(:seed)
    end
  end
end
