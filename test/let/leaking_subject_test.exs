defmodule LeakingSubjectTest do
  use ExUnit.Case

  @code1 (quote do
    defmodule SomeSpec do
      use ESpec
      describe "first" do
        subject do: []
        it "is empty by default", do: should be_empty
      end

      it do: should be_empty
    end
  end)

  @code2 (quote do
    defmodule SomeSpec do
      use ESpec
      describe "first" do
        subject do: []
        it "is empty by default", do: should be_empty
      end

      it do: is_expected |> to(be_empty)
    end
  end)

  @code3 (quote do
    defmodule SomeSpec do
      use ESpec
      describe "first" do
        subject do: []
        it "is empty by default", do: should be_empty
      end

      it do: is_expected.to be_empty
    end
  end)


  test "code1" do
    assert_raise ESpec.LetError, "The subject is not defined in the current scope!", fn ->
      Code.compile_quoted(@code1)
    end
  end

  test "code2" do
    assert_raise ESpec.LetError, "The subject is not defined in the current scope!", fn ->
      Code.compile_quoted(@code2)
    end
  end

  test "code3" do
    assert_raise ESpec.LetError, "The subject is not defined in the current scope!", fn ->
      Code.compile_quoted(@code3)
    end
  end
end
