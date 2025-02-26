defmodule ESpec.SuiteRunner do
  @moduledoc """
  Defines functions for running specs in modules.
  """

  alias ESpec.Configuration
  alias ESpec.Example
  alias ESpec.ExampleRunner

  @doc """
  Runs `before_all` hook, examples and then `after_all` hook.
  """
  def run(module, opts, shuffle \\ true) do
    run_before_all(module)
    examples = run_module_examples(module, opts, shuffle)
    run_after_all(module)
    examples
  end

  defp run_module_examples(module, opts, shuffle) do
    examples_to_run = filter(module.examples(), opts)

    if shuffle do
      run_examples(Enum.shuffle(examples_to_run))
    else
      run_examples(examples_to_run)
    end
  end

  @doc "Runs examples."
  def run_examples(examples, sync \\ Configuration.get(:sync)) do
    if sync do
      run_sync(examples)
    else
      {async, sync} = partition_async(examples)
      run_async(async) ++ run_sync(sync)
    end
  end

  @doc false
  def partition_async(examples) do
    Enum.split_with(examples, &(Example.extract_option(&1, :async) === true))
  end

  defp run_before_all(module) do
    if Enum.member?(module.__info__(:functions), {:before_all_function, 0}) do
      module.before_all_function()
    end
  end

  defp run_after_all(module) do
    if Enum.member?(module.__info__(:functions), {:after_all_function, 0}) do
      module.after_all_function()
    end
  end

  defp run_async(examples) do
    examples
    |> Task.async_stream(&ExampleRunner.run/1, timeout: :infinity)
    |> Stream.map(fn task_result ->
      case task_result do
        {:ok, example_result} -> example_result
        {:exit, reason} -> raise "Asynchronous test run exited with reason: #{inspect(reason)}"
      end
    end)
    |> Enum.to_list()
  end

  defp run_sync(examples), do: Enum.map(examples, &ExampleRunner.run(&1))

  @doc false
  def filter(examples, opts) do
    file_opts = opts[:file_opts] || []
    examples = filter_shared(examples)

    examples = if Enum.any?(file_opts), do: file_opts_filter(examples, file_opts), else: examples
    examples = if opts[:focus], do: filter_focus(examples), else: examples
    examples = if opts[:only], do: filter_only(examples, opts[:only]), else: examples
    examples = if opts[:exclude], do: filter_only(examples, opts[:exclude], true), else: examples
    examples = if opts[:string], do: filter_string(examples, opts[:string]), else: examples

    examples
  end

  defp filter_shared(examples), do: Enum.filter(examples, &(!&1.shared))

  defp file_opts_filter(examples, file_opts) do
    grouped_by_file = Enum.group_by(examples, fn example -> example.file end)

    filtered =
      Enum.reduce(grouped_by_file, [], fn {file, exs}, acc ->
        opts = opts_for_file(file, file_opts)
        line = Keyword.get(opts, :line)
        if line, do: examples_for_line(exs, line, acc), else: acc ++ exs
      end)

    filtered
  end

  defp examples_for_line(exs, line, acc) do
    block_filtered = filtered_examples_within_block(exs, line)

    if Enum.empty?(block_filtered) do
      closest = get_closest(Enum.map(exs, & &1.line), line)
      acc ++ Enum.filter(exs, &(&1.line == closest))
    else
      acc ++ block_filtered
    end
  end

  defp filtered_examples_within_block(examples, line) do
    Enum.filter(examples, fn ex ->
      ex
      |> Example.extract_contexts()
      |> Enum.map(fn c -> c.line end)
      |> Enum.member?(line)
    end)
  end

  defp get_closest(arr, value) do
    arr = Enum.sort(arr)

    line =
      arr
      |> Enum.reverse()
      |> Enum.find(fn l -> l <= value end)

    if line, do: line, else: hd(arr)
  end

  defp opts_for_file(file, opts_list) do
    case opts_list |> Enum.find(fn {k, _} -> k == file end) do
      {_file, opts} -> opts
      nil -> []
    end
  end

  defp filter_focus(examples) do
    Enum.filter(examples, fn example ->
      contexts = Example.extract_contexts(example)
      example.opts[:focus] || Enum.any?(contexts, & &1.opts[:focus])
    end)
  end

  defp filter_string(examples, string) do
    Enum.filter(examples, fn example ->
      description = Enum.join([example.description | Example.context_descriptions(example)])
      String.contains?(description, string)
    end)
  end

  defp filter_only(examples, only, reverse \\ false) do
    [key, value] = extract_opts(only)

    Enum.filter(examples, fn example ->
      tag_values = filter_tag_value(example, key)

      if reverse do
        if Enum.empty?(tag_values), do: true, else: !any_with_tag?(tag_values, value)
      else
        any_with_tag?(tag_values, value)
      end
    end)
  end

  defp filter_tag_value(example, key) do
    contexts = Example.extract_contexts(example)
    key = String.to_atom(key)
    example_tag_value = example.opts[key]
    context_tag_values = Enum.map(contexts, & &1.opts[key])
    Enum.filter([example_tag_value | context_tag_values], & &1)
  end

  defp any_with_tag?(tag_values, value) do
    Enum.any?(tag_values, &any_condition(&1, value))
  end

  defp any_condition(tag, value) do
    cond do
      is_atom(tag) ->
        if value, do: Atom.to_string(tag) == value, else: tag

      is_integer(tag) ->
        if value, do: Integer.to_string(tag) == value, else: tag

      true ->
        if value, do: tag == value, else: tag
    end
  end

  defp extract_opts(key_value) do
    if String.match?(key_value, ~r/:/) do
      String.split(key_value, ":")
    else
      [key_value, false]
    end
  end
end
