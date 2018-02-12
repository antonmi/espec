defmodule SubjectTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    subject(10)
    it do: "subject = #{subject()}"

    context "Redefine" do
      subject! do: 10 + 10
      it do: "subject = #{subject()}"
    end

    context "Function" do
      subject fn -> 5 end

      it do: expect(subject().()).to(eq(5))
      it do: subject().() |> should(eq 5)

      it do: is_expected().to_not(raise_exception())
      it do: should_not(raise_exception())
    end
  end

  setup_all do
    {:ok,
     ex1: Enum.at(SomeSpec.examples(), 0),
     ex2: Enum.at(SomeSpec.examples(), 1),
     ex3: Enum.at(SomeSpec.examples(), 2),
     ex4: Enum.at(SomeSpec.examples(), 3),
     ex5: Enum.at(SomeSpec.examples(), 4),
     ex6: Enum.at(SomeSpec.examples(), 5)}
  end

  test "run ex1", context do
    example = ESpec.ExampleRunner.run(context[:ex1])
    assert(example.result == "subject = 10")
  end

  test "run ex2", context do
    example = ESpec.ExampleRunner.run(context[:ex2])
    assert(example.result == "subject = 20")
  end

  test "run ex3 an ex4", context do
    example = ESpec.ExampleRunner.run(context[:ex3])
    assert(example.status == :success)
    example = ESpec.ExampleRunner.run(context[:ex4])
    assert(example.status == :success)
  end

  test "run ex5 and ex6", context do
    example = ESpec.ExampleRunner.run(context[:ex5])
    assert(example.status == :success)
    example = ESpec.ExampleRunner.run(context[:ex6])
    assert(example.status == :success)
  end
end
