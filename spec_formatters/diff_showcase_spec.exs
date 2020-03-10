Code.require_file("spec_formatters/custom_formatter.ex")
Code.require_file("spec_formatters/spec_helper.exs")

defmodule DiffShowcaseSpec do
  use ESpec, async: true

  it "shows eq" do
    expect([1 + 1]) |> to(eq 2)
  end

  it "shows eql" do
    expect(" one") |> to(eq "none ")
  end

  it "shows be" do
    expect(2.0) |> to(be 3)
  end

  it "shows match_list" do
    expect([1, 2, 2, 15, 19]) |> to(match_list([1, 2, 5, 3, 19]))
  end

  it "shows contain_exactly" do
    expect([1, "steady", 2.0, :more]) |> to(contain_exactly([1, 9.1, :now, "ready"]))
  end

  it "shows have_at" do
    expect([6, 9]) |> to(have_at(1, 8))
  end

  it "passed have_first" do
    expect(["first", "second", "last"]) |> to(have_first("first"))
  end

  it "shows have_last" do
    expect(["first", "second", "last"]) |> to(have_last("past"))
  end

  it "shows have_hd" do
    expect(["first", "rest", "more"]) |> to(have_hd("head"))
  end

  it "shows have_tl" do
    expect(["first", "rest", "more"]) |> to(have_tl(["rest", "last"]))
  end

  it "shows start_with" do
    expect("a lot of engine noise in the morning") |> to(start_with("starter engine"))
  end

  it "shows end_with" do
    expect("very big party") |> to(end_with("sleep"))
  end

  it "shows a diff between big strings" do
    expect(String.duplicate("external", 100))
    |> to(eq(String.duplicate("expected", 100)))
  end

  it "shows a diff between big maps" do
    expect(%{
      "field one" => "23",
      "field two" => "v2",
      "a longer field three" => "23",
      "f4" => "v2"
    })
    |> to(
      eq(%{
        "field X" => "15",
        "field two" => "v2",
        "a longer field three5" => "v",
        "field one6" => "v"
      })
    )
  end

  defp inside_function(x) do
    # some code
    Process.alive?(self())
    expect(x) |> to(be(3))
    # some more code
    Process.alive?(self())
  end

  defp inside_function_wrapper(2.09 = x) do
    expect(x) |> to(be(3))
  end

  defp inside_function_wrapper(x) do
    # some code
    Process.alive?(self())
    inside_function(x)
    # some more code
    Process.alive?(self())
  end

  it "shows a stacktrace for a function" do
    inside_function_wrapper(2.09)
  end

  it "shows a stacktrace for a function in a function" do
    inside_function_wrapper(3.90)
  end
end
