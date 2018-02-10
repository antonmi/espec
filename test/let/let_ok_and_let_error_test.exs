defmodule LetOkAndLetErrorTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    def ok_fun, do: {:ok, 10}
    def error_fun, do: {:error, 20}

    context "let_ok and let_ok!" do
      let_ok :ok_result, do: ok_fun()
      let_ok! :ok_result!, do: ok_fun()

      it do: expect(ok_result()).to eq(10)
      it do: expect(ok_result!()).to eq(10)
    end

    context "let_error and let_error!" do
      let_error :error_result, do: error_fun()
      let_error! :error_result!, do: error_fun()

      it do: expect(error_result()).to eq(20)
      it do: expect(error_result!()).to eq(20)
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
    example = ESpec.ExampleRunner.run(context[:ex1])
    assert(example.status == :success)
  end

  test "run ex2", context do
    example = ESpec.ExampleRunner.run(context[:ex2])
    assert(example.status == :success)
  end

  test "run ex3", context do
    example = ESpec.ExampleRunner.run(context[:ex3])
    assert(example.status == :success)
  end

   test "run ex5", context do
    example = ESpec.ExampleRunner.run(context[:ex4])
    assert(example.status == :success)
  end
end
