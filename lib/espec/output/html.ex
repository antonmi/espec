defmodule ESpec.Output.Html do
  @moduledoc """
  Generate json output.
  """
  alias ESpec.Example
  @doc "Format the final result."
  def format_result(examples, times, _opts) do
    tree = context_tree(examples)
    html = make_html(tree)
    summary = format_summary(examples, times)
    string = EEx.eval_file(template_path, [examples: html, summary: summary])
    String.replace(string, "\n", "")
  end
  
  @doc "Format an example result."
  def format_example(example, opts), do: ""

  defp template_path, do: Path.join(Path.dirname(__ENV__.file), "templates/html.html.eex")
  
  defp context_tree(examples) do
    examples
    |> Enum.reduce({HashDict.new, []}, fn(ex, acc) ->
      contexts = Enum.filter(ex.context, &(&1.__struct__ == ESpec.Context))
      put_deep(acc, contexts, ex)
    end)
  end

  defp put_deep({dict, values}, [el | tl], value) when length(tl) > 0 do
    d = case HashDict.get(dict, el) do
      {inner, vals} -> put_deep({inner, vals}, tl, value)
      nil -> put_deep({HashDict.new, []}, tl, value)
    end 
    {HashDict.put(dict, el, d), values}
  end

  defp put_deep({dict, values}, [el], value) do
    new_dict = case HashDict.get(dict, el) do
      {inner, vals} -> HashDict.put(dict, el, {inner, [value | vals]})
      nil -> HashDict.put(dict, el, {HashDict.new, [value]})
      end
    {new_dict, values}
  end 

  defp put_deep({dict, values}, [], value) do
    {dict, [value | values]}
  end

  defp make_html({dict, values}) do
    lis = Enum.reduce(values, "", fn(ex, acc) ->    
      acc <> "<li class='#{li_class(ex)}'>#{ex_desc(ex)}</li>"
    end) 
    uls = Enum.reduce(dict, lis, fn({key, d}, acc) -> 
      mainli = "<li class='context'>#{key.description}</li>"
      acc <> "<ul>#{mainli}" <> make_html(d) <> "</ul>"
    end)
    uls
  end

  def ex_desc(ex) do
    res = if String.length(ex.description) > 0 do 
      ex.description
    else
      if ex.status == :failure, do: ex.error.message, else: ex.result
    end
    String.replace(res, "\"", "'")
  end

  defp li_class(ex), do: ex.status

  def format_summary(examples, {start_loading_time, finish_loading_time, finish_specs_time}) do
    pending = Example.pendings(examples)
    failed = Example.failure(examples)
    load_time = :timer.now_diff(finish_loading_time, start_loading_time)
    spec_time = :timer.now_diff(finish_specs_time, finish_loading_time)
    {
      Enum.count(examples), Enum.count(failed), Enum.count(pending),
      us_to_sec(load_time + spec_time), us_to_sec(load_time), us_to_sec(spec_time)
    }
  end

  defp us_to_sec(us), do: div(us, 10000) / 100
end
