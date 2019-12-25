defmodule Formatters.DocDiffTest do
  use ExUnit.Case, async: true

  @durations {{1_436, 865_768, 500_000}, {1_436, 865_768, 500_100}, {1_436, 865_768, 500_200}}

  def output(examples) do
    examples
    |> ESpec.SuiteRunner.run_examples(true)
    |> ESpec.Formatters.Doc.format_result(@durations, %{diff_enabled?: true})
  end

  #
  # contain_exactly
  #

  test "failed contains_exactly with diff" do
    defmodule SomeSpecContainsExactly do
      use ESpec
      it do: expect([1, 48, 5]) |> to(contain_exactly([1, 48, 22]))
    end

    output = output(SomeSpecContainsExactly.examples())

    assert String.contains?(output, "\n\t  \e[36mexpected:\e[0m [1, \e[31m22\e[0m, 48]\n")
    assert String.contains?(output, "\n\t  \e[36mactual:\e[0m   [1, \e[32m5\e[0m, 48]\n")
  end

  #
  # eq & eql
  #

  test "failed eq with diff", context do
    defmodule SomeSpecEq do
      use ESpec
      it do: expect([1, 28, 3]) |> to(eq([1, 4, 3]))
    end

    output = output(SomeSpecEq.examples())

    assert String.contains?(output, "\n\t  \e[36mexpected:\e[0m [1, \e[31m4\e[0m, 3]\n")
    assert String.contains?(output, "\n\t  \e[36mactual:\e[0m   [1, \e[32m28\e[0m, 3]\n")
  end

  test "failed eq with diff (nil subject)" do
    defmodule SomeSpecEqNil do
      use ESpec
      it do: expect(nil) |> to(eq([1, 4, 3]))
    end

    output = output(SomeSpecEqNil.examples())

    assert String.contains?(output, "\n\t  \e[36mexpected:\e[0m [1, 4, 3]\n")
    assert String.contains?(output, "\n\t  \e[36mactual:\e[0m   nil\n")
  end

  test "failed eql with diff" do
    defmodule SomeSpecEql do
      use ESpec
      it do: expect(1) |> to(eql(1.0))
    end

    output = output(SomeSpecEql.examples())

    assert String.contains?(output, "\n\t  \e[36mexpected:\e[0m 1.0\n")
    assert String.contains?(output, "\n\t  \e[36mactual:\e[0m   1\n")
  end

  test "failed eq with very long string" do
    defmodule SomeSpecEqLongString do
      use ESpec

      it do:
           expect(String.duplicate("external", 1000))
           |> to(eq(String.duplicate("expected", 1000)))
    end

    output = output(SomeSpecEqLongString.examples())

    assert String.contains?(
             output,
             "\n\t  \e[36mexpected:\e[0m \"#{String.duplicate("expected", 1000)}\"\n"
           )

    assert String.contains?(
             output,
             "\n\t  \e[36mactual:\e[0m   \"#{String.duplicate("external", 1000)}\"\n"
           )
  end

  test "failed negative eq without diff" do
    defmodule SomeSpecNotEq do
      use ESpec
      it do: expect(5.0) |> not_to(eq(5))
    end

    output = output(SomeSpecNotEq.examples())

    refute String.contains?(output, "\n\t  \e[36mexpected:")
    refute String.contains?(output, "\n\t  \e[36mactual:")
  end

  test "failed negative eql without diff", context do
    defmodule SomeSpecNotEql do
      use ESpec
      it do: expect(17) |> not_to(eql(17))
    end

    output = output(SomeSpecNotEql.examples())

    refute String.contains?(output, "\n\t  \e[36mexpected:")
    refute String.contains?(output, "\n\t  \e[36mactual:")
  end

  #
  # have_at
  #

  test "failed have_at with diff" do
    defmodule SomeSpecHaveAt do
      use ESpec
      it do: expect([1, 2]) |> to(have_at(1, 10))
    end

    output = output(SomeSpecHaveAt.examples())

    assert String.contains?(output, "\n\t  \e[36mexpected:\e[0m \e[31m10\e[0m\n")
    assert String.contains?(output, "\n\t  \e[36mactual:\e[0m   \e[32m2\e[0m\n")
  end

  test "failed have_at on empty list with diff" do
    defmodule SomeSpecHaveAtOnEmptyList do
      use ESpec
      it do: expect([]) |> to(have_at(0, 65))
    end

    output = output(SomeSpecHaveAtOnEmptyList.examples())

    assert String.contains?(output, "\n\t  \e[36mexpected:\e[0m 65\n")
    assert String.contains?(output, "\n\t  \e[36mactual:\e[0m   nil\n")
  end

  test "failed negative have_at without diff" do
    defmodule SomeSpecNotHaveAt do
      use ESpec
      it do: expect([1, 2]) |> not_to(have_at(0, 1))
    end

    output = output(SomeSpecNotHaveAt.examples())

    refute String.contains?(output, "\n\t  \e[36mexpected:")
    refute String.contains?(output, "\n\t  \e[36mactual:")
  end

  #
  # have_first
  #

  test "failed have_first with diff" do
    defmodule SomeSpecHaveFirst do
      use ESpec
      it do: expect([1, 2]) |> to(have_first(10))
    end

    output = output(SomeSpecHaveFirst.examples())

    assert String.contains?(output, "\n\t  \e[36mexpected:\e[0m 1\e[31m0\e[0m\n")
    assert String.contains?(output, "\n\t  \e[36mactual:\e[0m   1\n")
  end

  test "failed have_first on empty list with diff" do
    defmodule SomeSpecHaveFirstOnEmptyList do
      use ESpec
      it do: expect([]) |> to(have_first(65))
    end

    output = output(SomeSpecHaveFirstOnEmptyList.examples())

    assert String.contains?(output, "\n\t  \e[36mexpected:\e[0m 65\n")
    assert String.contains?(output, "\n\t  \e[36mactual:\e[0m   nil\n")
  end

  test "failed negative have_first without diff" do
    defmodule SomeSpecNotHaveFirst do
      use ESpec
      it do: expect([1, 2]) |> not_to(have_first(1))
    end

    output = output(SomeSpecNotHaveFirst.examples())

    refute String.contains?(output, "\n\t  \e[36mexpected:")
    refute String.contains?(output, "\n\t  \e[36mactual:")
  end

  #
  # have_last
  #

  test "failed have_last with diff" do
    defmodule SomeSpecHaveLast do
      use ESpec
      it do: expect([1, 2]) |> to(have_last(20))
    end

    output = output(SomeSpecHaveLast.examples())

    assert String.contains?(output, "\n\t  \e[36mexpected:\e[0m 2\e[31m0\e[0m\n")
    assert String.contains?(output, "\n\t  \e[36mactual:\e[0m   2\n")
  end

  test "failed have_last on empty list with diff" do
    defmodule SomeSpecHaveLastOnEmptyList do
      use ESpec
      it do: expect([]) |> to(have_last(82))
    end

    output = output(SomeSpecHaveLastOnEmptyList.examples())

    assert String.contains?(output, "\n\t  \e[36mexpected:\e[0m 82\n")
    assert String.contains?(output, "\n\t  \e[36mactual:\e[0m   nil\n")
  end

  test "failed negative have_last without diff" do
    defmodule SomeSpecNotHaveLast do
      use ESpec
      it do: expect([1, 2]) |> not_to(have_last(2))
    end

    output = output(SomeSpecNotHaveLast.examples())

    refute String.contains?(output, "\n\t  \e[36mexpected:")
    refute String.contains?(output, "\n\t  \e[36mactual:")
  end

  #
  # have_hd
  #

  test "failed have_hd with diff" do
    defmodule SomeSpecHaveHd do
      use ESpec
      it do: expect([1, 2]) |> to(have_hd(10))
    end

    output = output(SomeSpecHaveHd.examples())

    assert String.contains?(output, "\n\t  \e[36mexpected:\e[0m 1\e[31m0\e[0m\n")
    assert String.contains?(output, "\n\t  \e[36mactual:\e[0m   1\n")
  end

  test "failed negative have_hd without diff" do
    defmodule SomeSpecNotHaveHd do
      use ESpec
      it do: expect([1, 2]) |> not_to(have_hd(1))
    end

    output = output(SomeSpecNotHaveHd.examples())

    refute String.contains?(output, "\n\t  \e[36mexpected:")
    refute String.contains?(output, "\n\t  \e[36mactual:")
  end

  #
  # have_tl
  #

  test "failed have_tl with diff" do
    defmodule SomeSpecHaveTl do
      use ESpec
      it do: expect([1, 2]) |> to(have_tl(20))
    end

    output = output(SomeSpecHaveTl.examples())

    assert String.contains?(output, "\n\t  \e[36mexpected:\e[0m 20\n")
    assert String.contains?(output, "\n\t  \e[36mactual:\e[0m   [2]\n")
  end

  test "failed have_tl with longer list and diff" do
    defmodule SomeSpecHaveTlWithLongerList do
      use ESpec
      it do: expect([1, 2, 82]) |> to(have_tl(82))
    end

    output = output(SomeSpecHaveTlWithLongerList.examples())

    assert String.contains?(output, "\n\t  \e[36mexpected:\e[0m 82\n")
    assert String.contains?(output, "\n\t  \e[36mactual:\e[0m   [2, 82]\n")
  end

  test "failed negative have_tl without diff" do
    defmodule SomeSpecNotHaveTl do
      use ESpec
      it do: expect([1, 2]) |> not_to(have_tl(2))
    end

    output = output(SomeSpecNotHaveTl.examples())

    refute String.contains?(output, "\n\t  \e[36mexpected:")
    refute String.contains?(output, "\n\t  \e[36mactual:")
  end

  #
  # start_with
  #

  test "failed start_with with diff" do
    defmodule SomeSpecStartWith do
      use ESpec

      it do:
           expect("string that starts with something")
           |> to(start_with("string that doesnt't start with"))
    end

    output = output(SomeSpecStartWith.examples())

    assert String.contains?(
             output,
             "\n\t  \e[36mexpected:\e[0m \"string that \e[31mdoe\e[0ms\e[31mn\e[0mt\e[31m't st\e[0mart with\"\n"
           )

    assert String.contains?(
             output,
             "\n\t  \e[36mactual:\e[0m   \"string that start\e[32ms\e[0m with\e[32m somethi\e[0m\"\n"
           )
  end

  test "failed start_with on empty string with diff" do
    defmodule SomeSpecStartWithOnEmptyString do
      use ESpec
      it do: expect("") |> to(start_with("start"))
    end

    output = output(SomeSpecStartWithOnEmptyString.examples())

    assert String.contains?(output, "\n\t  \e[36mexpected:\e[0m \"start\"\n")
    assert String.contains?(output, "\n\t  \e[36mactual:\e[0m   \"\"\n")
  end

  test "failed negative start_with without diff" do
    defmodule SomeSpecNotStartWith do
      use ESpec
      it do: expect("startup") |> to(start_with("start"))
    end

    output = output(SomeSpecNotStartWith.examples())

    refute String.contains?(output, "\n\t  \e[36mexpected:")
    refute String.contains?(output, "\n\t  \e[36mactual:")
  end

  #
  # end_with
  #

  test "failed end_with with diff" do
    defmodule SomeSpecEndWith do
      use ESpec

      it do:
           expect("string that ends with something")
           |> to(end_with("string that doesnt't end with"))
    end

    output = output(SomeSpecEndWith.examples())

    assert String.contains?(
             output,
             "\n\t  \e[36mexpected:\e[0m \"\e[31mst\e[0mring that \e[31mdo\e[0me\e[31ms\e[0mn\e[31mt't en\e[0md with\"\n"
           )

    assert String.contains?(
             output,
             "\n\t  \e[36mactual:\e[0m   \"ring that end\e[32ms\e[0m with\e[32m something\e[0m\"\n"
           )
  end

  test "failed end_with on empty string with diff" do
    defmodule SomeSpecEndWithOnEmptyString do
      use ESpec
      it do: expect("") |> to(end_with("end"))
    end

    output = output(SomeSpecEndWithOnEmptyString.examples())

    assert String.contains?(output, "\n\t  \e[36mexpected:\e[0m \"end\"\n")
    assert String.contains?(output, "\n\t  \e[36mactual:\e[0m   \"\"\n")
  end

  test "failed negative end_with without diff" do
    defmodule SomeSpecNotEndWith do
      use ESpec
      it do: expect("elixir RSpec style specs") |> to(end_with("specs"))
    end

    output = output(SomeSpecNotEndWith.examples())

    refute String.contains?(output, "\n\t  \e[36mexpected:")
    refute String.contains?(output, "\n\t  \e[36mactual:")
  end
end
