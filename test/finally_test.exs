defmodule FinallyTest do
  use ExUnit.Case

  defmodule SomeSpec do
    use ESpec

    before do: {:ok, a: 1}

    finally do: Application.put_env(:espec, :finally_a, shared[:b])

    finally do
      Application.put_env(:espec, :finally_b, 1)
      {:ok, b: shared[:a] + 1}
    end

    it do: "some test"

    context "error or throw" do
      context "throw term" do
        finally do: throw(:some_term)
        it do: true
      end

      context "fail " do
        finally do: raise("Error")
        it do: true
      end
    end

    # this finally is not accessible
    finally do: Application.put_env(:espec, :finally_c, 3)
  end

  setup_all do
    {:ok,
     ex1: Enum.at(SomeSpec.examples(), 0),
     ex2: Enum.at(SomeSpec.examples(), 1),
     ex3: Enum.at(SomeSpec.examples(), 2)}
  end

  test "run ex1", context do
    ESpec.ExampleRunner.run(context[:ex1])
    assert(Application.get_env(:espec, :finally_a) == 2)
    assert(Application.get_env(:espec, :finally_b) == 1)
    assert(Application.get_env(:espec, :finally_c) == nil)
  end

  test "run example which throws term", context do
    example = ESpec.ExampleRunner.run(context[:ex2])
    assert example.status == :failure
    assert String.match?(example.error.message, ~r/throw :some_term/)
  end

  test "run example which raises error", context do
    example = ESpec.ExampleRunner.run(context[:ex3])
    assert example.status == :failure
    assert String.match?(example.error.message, ~r/\(RuntimeError\) Error/)
  end
end

defmodule FinallyTestWithExceptions do
  use ExUnit.Case

  defmodule Spec.FailingSpec do
    use ESpec

    before do: {:ok, foo: :bar}

    finally do
      Application.put_env(:espec, :finally_value, 100_500)
      Application.put_env(:espec, :shared_value, shared[:foo])
    end

    it "failing example 1", do: expect(1 |> to(eq 2))
    it "failing exampe 2", do: raise("Some error")
  end

  setup do
    Application.put_env(:espec, :finally_value, nil)
    Application.put_env(:espec, :finally_value, nil)

    {:ok,
     ex1: Enum.at(Spec.FailingSpec.examples(), 0), ex2: Enum.at(Spec.FailingSpec.examples(), 1)}
  end

  test "run ex1", context do
    example = ESpec.ExampleRunner.run(context[:ex1])
    assert(example.status == :failure)
    assert(Application.get_env(:espec, :finally_value) == 100_500)
    assert(Application.get_env(:espec, :shared_value) == :bar)
  end

  test "run ex2", context do
    example = ESpec.ExampleRunner.run(context[:ex2])
    assert(example.status == :failure)
    assert(Application.get_env(:espec, :finally_value) == 100_500)
    assert(Application.get_env(:espec, :shared_value) == :bar)
  end
end
