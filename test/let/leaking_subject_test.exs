defmodule LeakingSubjectTest do
  use ExUnit.Case

  defmodule SomeSpec do
    use ESpec

    ESpec.Context.describe "first" do
      subject do: []

      it "is empty by default", do: should be_empty
    end

    ESpec.Context.describe "second" do
      it do: should be_empty
      it do: is_expected |> to(be_empty)
      it do: is_expected.to be_empty
    end
  end

  defmodule SomeSpec2 do
    use ESpec
    ESpec.Context.describe "second" do
      it do: should(eq 1)
    end
    ESpec.Context.describe "first" do
      subject do: 1
      it do: should(eq 1)
    end
  end

  setup_all do
    {:ok,
      ex1: Enum.at(SomeSpec.examples, 0),
      ex2: Enum.at(SomeSpec.examples, 1),
      ex3: Enum.at(SomeSpec.examples, 2),
      ex4: Enum.at(SomeSpec.examples, 3),

      ex5: Enum.at(SomeSpec2.examples, 0),
      ex6: Enum.at(SomeSpec2.examples, 1),
    }
  end

  test "runs ex1 then ex2", context do
    example = ESpec.ExampleRunner.run(context[:ex1])
    assert example.status == :success

    example = ESpec.ExampleRunner.run(context[:ex2])
    assert example.status == :failure
    assert example.error.message =~ "\(ESpec.LetError\) The subject is not defined in the current scope!"
  end

  test "runs ex1 then ex3", context do
    example = ESpec.ExampleRunner.run(context[:ex1])
    assert example.status == :success

    example = ESpec.ExampleRunner.run(context[:ex3])
    assert example.status == :failure
    assert example.error.message =~ "\(ESpec.LetError\) The subject is not defined in the current scope!"
  end

  test "runs ex1 then ex4", context do
    example = ESpec.ExampleRunner.run(context[:ex1])
    assert example.status == :success

    example = ESpec.ExampleRunner.run(context[:ex4])
    assert example.status == :failure
    assert example.error.message =~ "\(ESpec.LetError\) The subject is not defined in the current scope!"
  end

  test "runs ex6 then ex5", context do
    example = ESpec.ExampleRunner.run(context[:ex6])
    assert example.status == :success

    example = ESpec.ExampleRunner.run(context[:ex5])
    assert example.status == :failure
    assert example.error.message =~ "\(ESpec.LetError\) The subject is not defined in the current scope!"
  end
end
