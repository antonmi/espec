defmodule LeakingLetTest do
  use ExUnit.Case

  @code1 (quote do
    defmodule SomeSpec do
      use ESpec
      describe "first" do
        let :a, do: 1
        it do: expect a |> to(eq 1)
      end
      describe "second" do
        it do: expect a |> to(eq 1)
      end
    end
  end)

  @code2 (quote do
    defmodule SomeSpec do
      use ESpec
      describe "first" do
        let :a, do: 1
        it do: expect a |> to(eq 1)
      end
      it do: expect a |> to(eq 1)
    end
  end)

  test "code1" do
    assert_raise ESpec.LetError, "The let function `a/0` is not defined in the current scope!", fn ->
      Code.compile_quoted(@code1)
    end
  end

  test "code2" do
    assert_raise ESpec.LetError, "The let function `a/0` is not defined in the current scope!", fn ->
      Code.compile_quoted(@code2)
    end
  end
end
