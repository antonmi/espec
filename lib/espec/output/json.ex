defmodule ESpec.Output.Json do
  @moduledoc """
  Generates json output.
  """
  alias ESpec.Example
  @doc "Formats the final result."
  def format_result(examples, times, _opts) do
    pending = Example.pendings(examples)
    failed = Example.failure(examples)
    list = [
      format_pending(pending), format_failed(failed), format_success(Example.success(examples))
    ] |> List.flatten
    summary = format_summary(examples, pending, failed, times)
    string = EEx.eval_file(template_path, [examples: list, summary: summary])
    String.replace(string, "\n", "")
  end

  @doc "Formats an example result."
  def format_example(_example, _opts), do: ""

  defp template_path, do: Path.join(Path.dirname(__ENV__.file), "templates/json.json.eex")

  defp format_failed(examples), do: Enum.map(examples, &(do_format_example(&1, &1.error.message)))

  defp format_pending(examples), do: Enum.map(examples, &(do_format_example(&1, &1.result)))

  def format_success(examples), do: Enum.map(examples, &(do_format_example(&1, &1.result)))

  defp do_format_example(example, info) do
    description = one_line_description(example)
    {description, "#{example.file}:#{example.line}", example.status, String.replace("#{info}", "\"", "'"), example.duration}
  end

  def format_summary(examples, pending, failed, {start_loading_time, finish_loading_time, finish_specs_time}) do
    load_time = :timer.now_diff(finish_loading_time, start_loading_time)
    spec_time = :timer.now_diff(finish_specs_time, finish_loading_time)
    seed = get_seed
    {
      Enum.count(examples), Enum.count(failed), Enum.count(pending),
      us_to_sec(load_time + spec_time), us_to_sec(load_time), us_to_sec(spec_time),
      seed
    }
  end

  defp us_to_sec(us), do: div(us, 10000) / 100

  defp one_line_description(example) do
    module = "#{example.module}" |> String.replace("Elixir.", "")
    [ module | ESpec.Example.context_descriptions(example)] ++ [example.description]
    |> Enum.join(" ") |> String.rstrip
  end

  defp get_seed do
    if ESpec.Configuration.get(:order) do
      false
    else
      ESpec.Configuration.get(:seed)
    end
  end
end
