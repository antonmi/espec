defmodule ConfigFinallyRaiseTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec
    it do: "some test"
  end

  setup_all do
    ESpec.configure fn(c) ->
      c.finally fn ->
        raise "An exception"
      end
    end

    {:ok, ex1: Enum.at(SomeSpec.examples, 0)}
  end

  test "run ex1", context do
    example = ESpec.ExampleRunner.run(context[:ex1])
    assert example.status == :failure
    assert String.match?(example.error.message, ~r/\(RuntimeError\) An exception/)
  end
end

defmodule ConfigFinallyThrowTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec
    it do: "some test"
  end

  setup_all do
    ESpec.configure fn(c) ->
      c.finally fn ->
        throw :some_term
      end
    end

    {:ok, ex2: Enum.at(SomeSpec.examples, 0)}
  end

  test "run ex2", context do
    example = ESpec.ExampleRunner.run(context[:ex2])
    assert example.status == :failure
    assert String.match?(example.error.message, ~r/throw :some_term/)
  end
end
