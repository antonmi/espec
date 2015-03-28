defmodule SubjectTest do

  use ExUnit.Case

  defmodule SomeSpec do
    use ESpec

    subject(10)
    it do: "subject = #{subject}"

    context "Redefine" do
      subject(20)
      it do: "subject = #{subject}"
    end

    context "Function" do
      subject fn -> 5 end
      it do: expect(subject.()).to eq(5)
      it do: is_expected.to_not raise_exception
    end
  end

  setup_all do
    {:ok,
      ex1: Enum.at(SomeSpec.examples, 0),
      ex2: Enum.at(SomeSpec.examples, 1),
      ex3: Enum.at(SomeSpec.examples, 2),
      ex4: Enum.at(SomeSpec.examples, 3)
    }
  end


  test "run ex1", context do
    example = ESpec.Runner.run_example(context[:ex1], SomeSpec)
    assert(example.result == "subject = 10")
  end

  test "run ex2", context do
    example = ESpec.Runner.run_example(context[:ex2], SomeSpec)
    assert(example.result == "subject = 20")
  end

  test "run ex3", context do
    example = ESpec.Runner.run_example(context[:ex3], SomeSpec)
    assert(example.status == :success)
  end

  test "run ex4", context do
    example = ESpec.Runner.run_example(context[:ex4], SomeSpec)
    assert(example.status == :success)
  end

end
