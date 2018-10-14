defmodule ExampleSpecPipe do
  use ESpec
  it do: expect(1) |> to(eq(2))
  it do: expect(1) |> not_to(eq(1))
  it do: expect(1) |> to_not(eq(1))

  it "is not a one liner" do
    a = 10
    expect(1) |> to(eq(a))
    # empty
  end

  subject(1)

  it do: is_expected() |> to(eq(2))
  it do: is_expected() |> not_to(eq(1))
  it do: is_expected() |> to_not(eq(1))

  it "is not a one liner with subject" do
    a = 10
    is_expected() |> to(eq(a))
    # empty
  end

  it "has 3 expects, the second fails" do
    expect(1) |> to_not(eq(2))
    expect(1) |> to(eql("1"))
    expect(1) |> not_to(eq(1))
  end

  it "has a failing expect in a function" do
    test_function(nil, nil)
  end

  defp test_function(_, _) do
    expect(1) |> to(eq("1"))
    expect(1) |> not_to(eq(1))
  end

  it "has a failing expect in some nested function call" do
    level1(nil)
  end

  defp level1(x) do
    # some code
    a = 1
    level2(x)
    # trying to prevent the compiler from optimizing this
    a
  end

  defp level2(x) do
    # some code
    a = 2
    level3(x)
    # trying to prevent the compiler from optimizing this
    a
  end

  defp level3(x) do
    # some code
    a = 3
    level4(x)
    # trying to prevent the compiler from optimizing this
    a
  end

  defp level4(x) do
    # some code
    a = 4
    expect(x) |> to(eq(""))
    # trying to prevent the compiler from optimizing this
    a
  end
end
