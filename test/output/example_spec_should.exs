defmodule ExampleSpecShould do
  use ESpec
  it do: 1 |> should(eq(2))
  it do: 1 |> should_not(eq(1))
  it do: 1 |> should_not(eq(1))
  it "is not a one liner" do
    a = 10
    1 |> should(eq(a))
    a
  end

  subject(1)

  it do: should(eq(2))
  it do: should_not(eq(1))
  it do: should_not(eq(1))
  it "is not a one liner with subject" do
    a = 10
    should(eq(a))
    a
  end

  it "has 3 expects, the second fails" do
    1 |> should_not(eq(2))
    1 |> should(eql("1"))
    1 |> should_not(eq(1))
  end

  it "has a failing expect in a function" do
    test_function(nil, nil)
  end

  defp test_function(_, _) do
    1 |> should(eq("1"))
    1 |> should_not(eq(1))
  end

  it "has a failing expect in some nested function call" do
    level1(nil)
  end

  defp level1(x) do
    a = 1 # some code
    level2(x)
    a # trying to prevent the compiler from optimizing this
  end

  defp level2(x) do
    a = 2 # some code
    level3(x)
    a # trying to prevent the compiler from optimizing this
  end

  defp level3(x) do
    a = 3 # some code
    level4(x)
    a # trying to prevent the compiler from optimizing this
  end

  defp level4(x) do
    a = 4 # some code
    expect(x).to(eq(""))
    a # trying to prevent the compiler from optimizing this
  end
end
