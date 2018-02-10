defmodule Formatters.DocStacktraceTest do
  use ExUnit.Case, async: true

  @durations {{1_436, 865_768, 500_000}, {1_436, 865_768, 500_100}, {1_436, 865_768, 500_200}}

  defp output(examples) do
    examples
    |> ESpec.SuiteRunner.run_examples(true)
    |> ESpec.Formatters.Doc.format_result(@durations, %{diff_enabled?: true})
  end

  defp assert_contains(output, string) do
    assert String.contains?(output, String.trim(string))
  end

  defp module_name(module) do
    String.replace_leading("#{module}", "Elixir.", "")
  end

  modules = [
    {"expect().to syntax", ExampleSpecDot, "example_spec_dot"},
    {"expect() |> to syntax", ExampleSpecPipe, "example_spec_pipe"},
    {"should syntax", ExampleSpecShould, "example_spec_should"}
  ]

  for {desc, module, file} <- modules do
    Code.require_file(Path.join(__DIR__, "#{file}.exs"))

    test desc do
      m = unquote(module)
      name = module_name(m)

      f =
        __DIR__
        |> Path.relative_to_cwd()
        |> Path.join("#{unquote(file)}.exs")

      output = output(m.examples)

      start_line = 3

      for line <- start_line..(start_line + 2) do
        assert_contains(output, """
        #{name}
        \t\e[36m#{f}:#{line}\e[0m
        \t\e[31mExpected
        """)
      end

      assert_contains(output, """
      liner
      \t\e[36m#{f}:#{start_line + 5}: (inside example)
      \t#{f}:#{start_line + 3}: (example)\e[0m
      \t\e[31mExpected
      """)

      start_line = 14

      for line <- start_line..(start_line + 2) do
        assert_contains(output, """
        #{name}
        \t\e[36m#{f}:#{line}\e[0m
        \t\e[31mExpected
        """)
      end

      assert_contains(output, """
      subject
      \t\e[36m#{f}:#{start_line + 5}: (inside example)
      \t#{f}:#{start_line + 3}: (example)\e[0m
      \t\e[31mExpected
      """)

      start_line = 23

      assert_contains(output, """
      has 3 expects, the second fails
      \t\e[36m#{f}:#{start_line + 2}: (inside example)
      \t#{f}:#{start_line}: (example)\e[0m
      \t\e[31mExpected
      """)

      start_line = 29
      function_first_line = 34

      assert_contains(output, """
      has a failing expect in a function
      \t\e[36m#{f}:#{function_first_line}: Elixir.#{name}.test_function/2
      \t#{f}:#{start_line}: (example)\e[0m
      \t\e[31mExpected
      """)

      start_line = 38
      first_function_line = 44

      assert_contains(output, """
      has a failing expect in some nested function call
      \t\e[36m#{f}:#{first_function_line + 18}: Elixir.#{name}.level4/1
      \t#{f}:#{first_function_line + 12}: Elixir.#{name}.level3/1
      \t#{f}:#{first_function_line + 6}: Elixir.#{name}.level2/1
      \t#{f}:#{first_function_line}: Elixir.#{name}.level1/1
      \t#{f}:#{start_line}: (example)\e[0m
      \t\e[31mExpected
      """)
    end
  end
end
