defmodule ESpec.DocExample do
  @moduledoc """
  Defines the 'extract' method with parse module content and return `%ESpec.DocExample{}` structs.
  The struct is used by 'ESpec.DocTest' module to build the specs.
  """

  @doc """
  DocExample struct:
  lhs - console input,
  rhs - console output,
  fun_arity - {fun, arity} tuple,
  line - line where function is definde,
  type - define the doc spec type (:test, :error or :inspect).
  Read 'ESpec.DocTest' doc for more info.
  """
  defstruct lhs: nil, rhs: nil, fun_arity: nil, line: nil, type: :test

  defmodule Error, do: defexception [:message]

  @doc "Extract module docs and returns a list of %ESpec.DocExample{} structs"
  def extract(module) do
    all_docs = Code.get_docs(module, :all)

    unless all_docs do
      raise Error, message:
        "could not retrieve the documentation for module #{inspect module}. " <>
        "The module was not compiled with documentation or its beam file cannot be accessed"
    end

    moduledocs = extract_from_moduledoc(all_docs[:moduledoc])

    docs = for doc <- all_docs[:docs],
               doc <- extract_from_doc(doc),
               do: doc

    moduledocs ++ docs
    |> Enum.map(&to_struct/1)
    |> List.flatten
  end

  def to_struct(%{exprs: list, fun_arity: fun_arity, line: line}) do
    Enum.map(list, &item_to_struct(&1, fun_arity, line))
  end

  defp item_to_struct({lhs, {:test, rhs}}, fun_arity, line) do
    %__MODULE__{lhs: String.strip(lhs), rhs: String.strip(rhs), fun_arity: fun_arity, line: line, type: :test}
  end

  defp item_to_struct({lhs, {:error, error_module, error_message}}, fun_arity, line) do
    %__MODULE__{lhs: String.strip(lhs), rhs: {error_module, error_message}, fun_arity: fun_arity, line: line, type: :error}
  end

  defp item_to_struct({lhs, {:inspect, string}}, fun_arity, line) do
    %__MODULE__{lhs: String.strip(lhs), rhs: string, fun_arity: fun_arity, line: line, type: :inspect}
  end

  defp extract_from_moduledoc({_, doc}) when doc in [false, nil], do: []

  defp extract_from_moduledoc({line, doc}) do
    extract_tests(line, doc)
  end

  defp extract_from_doc({_, _, _, _, doc}) when doc in [false, nil], do: []

  defp extract_from_doc({fa, line, _, _, doc}) do
    for test <- extract_tests(line, doc) do
      %{test | fun_arity: fa}
    end
  end

  defp extract_tests(line, doc) do
    lines = String.split(doc, ~r/\n/, trim: false) |> adjust_indent
    extract_tests(lines, line, "", "", [], true)
  end

  defp adjust_indent(lines) do
    adjust_indent(lines, [], 0, :text)
  end

  defp adjust_indent([], adjusted_lines, _indent, _) do
    Enum.reverse adjusted_lines
  end

  @iex_prompt ["iex>", "iex("]
  @dot_prompt ["...>", "...("]

  defp adjust_indent([line|rest], adjusted_lines, indent, :text) do
    case String.starts_with?(String.lstrip(line), @iex_prompt) do
      true  -> adjust_indent([line|rest], adjusted_lines, get_indent(line, indent), :prompt)
      false -> adjust_indent(rest, adjusted_lines, indent, :text)
    end
  end

  defp adjust_indent([line|rest], adjusted_lines, indent, check) when check in [:prompt, :after_prompt] do
    stripped_line = strip_indent(line, indent)

    case String.lstrip(line) do
      "" ->
        raise Error, message: "expected non-blank line to follow iex> prompt"
      ^stripped_line ->
        :ok
      _ ->
        raise Error, message: "indentation level mismatch: #{inspect line}, should have been #{indent} spaces"
    end

    if String.starts_with?(stripped_line, @iex_prompt ++ @dot_prompt) do
      adjust_indent(rest, [stripped_line|adjusted_lines], indent, :after_prompt)
    else
      next = if check == :prompt, do: :after_prompt, else: :code
      adjust_indent(rest, [stripped_line|adjusted_lines], indent, next)
    end
  end

  defp adjust_indent([line|rest], adjusted_lines, indent, :code) do
    stripped_line = strip_indent(line, indent)
    cond do
      stripped_line == "" ->
        adjust_indent(rest, [stripped_line|adjusted_lines], 0, :text)
      String.starts_with?(String.lstrip(line), @iex_prompt) ->
        adjust_indent([line|rest], adjusted_lines, indent, :prompt)
      true ->
        adjust_indent(rest, [stripped_line|adjusted_lines], indent, :code)
    end
  end

  defp get_indent(line, current_indent) do
    case Regex.run ~r/iex/, line, return: :index do
      [{pos, _len}] -> pos
      nil -> current_indent
    end
  end

  defp strip_indent(line, indent) do
    length = byte_size(line) - indent
    if length > 0 do
      :binary.part(line, indent, length)
    else
      ""
    end
  end

  defp extract_tests([], _line, "", "", [], _) do
    []
  end

  defp extract_tests([], _line, "", "", acc, _) do
    Enum.reverse(reverse_last_test(acc))
  end

  # End of input and we've still got a test pending.
  defp extract_tests([], _, expr_acc, expected_acc, [test=%{exprs: exprs}|t], _) do
    test = %{test | exprs: [{expr_acc, {:test, expected_acc}} | exprs]}
    Enum.reverse(reverse_last_test([test|t]))
  end

  # We've encountered the next test on an adjacent line. Put them into one group.
  defp extract_tests([<< "iex>", _ :: binary>>|_] = list, line, expr_acc, expected_acc, [test=%{exprs: exprs}|t], newtest) when expr_acc != "" and expected_acc != "" do
    test = %{test | exprs: [{expr_acc, {:test, expected_acc}} | exprs]}
    extract_tests(list, line, "", "", [test|t], newtest)
  end

  # Store expr_acc and start a new test case.
  defp extract_tests([<< "iex>", string :: binary>>|lines], line, "", expected_acc, acc, true) do
    acc = reverse_last_test(acc)
    test = %{line: line, fun_arity: nil, exprs: []}
    extract_tests(lines, line, string, expected_acc, [test|acc], false)
  end

  # Store expr_acc.
  defp extract_tests([<< "iex>", string :: binary>>|lines], line, "", expected_acc, acc, false) do
    extract_tests(lines, line, string, expected_acc, acc, false)
  end

  # Still gathering expr_acc. Synonym for the next clause.
  defp extract_tests([<< "iex>", string :: binary>>|lines], line, expr_acc, expected_acc, acc, newtest) do
    extract_tests(lines, line, expr_acc <> "\n" <> string, expected_acc, acc, newtest)
  end

  # Still gathering expr_acc. Synonym for the previous clause.
  defp extract_tests([<< "...>", string :: binary>>|lines], line, expr_acc, expected_acc, acc, newtest) when expr_acc != "" do
    extract_tests(lines, line, expr_acc <> "\n" <> string, expected_acc, acc, newtest)
  end

  # Expression numbers are simply skipped.
  defp extract_tests([<< "iex(", _ :: 8, string :: binary>>|lines], line, expr_acc, expected_acc, acc, newtest) do
    extract_tests(["iex" <> skip_iex_number(string)|lines], line, expr_acc, expected_acc, acc, newtest)
  end

  # Expression numbers are simply skipped redux.
  defp extract_tests([<< "...(", _ :: 8, string :: binary>>|lines], line, expr_acc, expected_acc, acc, newtest) do
    extract_tests(["..." <> skip_iex_number(string)|lines], line, expr_acc, expected_acc, acc, newtest)
  end

  # Skip empty or documentation line.
  defp extract_tests([_|lines], line, "", "", acc, _) do
    extract_tests(lines, line, "", "", acc, true)
  end

  # Encountered an empty line, store pending test
  defp extract_tests([""|lines], line, expr_acc, expected_acc, [test=%{exprs: exprs}|t], _) do
    test = %{test | exprs: [{expr_acc, {:test, expected_acc}} | exprs]}
    extract_tests(lines, line,  "", "", [test|t], true)
  end

  # Exception test.
  defp extract_tests([<< "** (", string :: binary >>|lines], line, expr_acc, "", [test=%{exprs: exprs}|t], newtest) do
    test = %{test | exprs: [{expr_acc, extract_error(string, "")} | exprs]}
    extract_tests(lines, line,  "", "", [test|t], newtest)
  end

  # Finally, parse expected_acc.
  defp extract_tests([expected|lines], line, expr_acc, expected_acc, [test=%{exprs: exprs}|t]=acc, newtest) do
    if expected =~ ~r/^#[A-Z][\w\.]*<.*>$/ do
      expected = expected_acc <> "\n" <> inspect(expected)
      test = %{test | exprs: [{expr_acc, {:inspect, expected}} | exprs]}
      extract_tests(lines, line,  "", "", [test|t], newtest)
    else
      extract_tests(lines, line, expr_acc, expected_acc <> "\n" <> expected, acc, newtest)
    end
  end

  defp extract_error(<< ")", t :: binary >>, acc) do
    {:error, Module.concat([acc]), String.strip(t)}
  end

  defp extract_error(<< h, t :: binary >>, acc) do
    extract_error(t, << acc :: binary, h >>)
  end

  defp skip_iex_number(<< ")", ">", string :: binary >>) do
    ">" <> string
  end

  defp skip_iex_number(<< _ :: 8, string :: binary >>) do
    skip_iex_number(string)
  end

  defp reverse_last_test([]), do: []
  defp reverse_last_test([test=%{exprs: exprs} | t]) do
    test = %{test | exprs: Enum.reverse(exprs)}
    [test | t]
  end
end
