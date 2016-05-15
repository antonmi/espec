defmodule LeakingLetTest do
  use ExUnit.Case

  defmodule SomeSpec do
    use ESpec
    describe "first" do
      let :a, do: 1
      it do: expect a |> to(eq 1)
    end
    describe "second" do
      it do: expect a |> to(eq 1)
    end
    it do: expect a |> to(eq 1)
  end

  defmodule SomeSpec2 do
    use ESpec
    describe "second" do
      it do: a |> should(eq 1)
    end
    describe "first" do
      let :a, do: 1
      it do: a |> should(eq 1)
    end
  end

  defmodule SomeSpec3 do
    use ESpec
    describe "example when local variable is the same as let" do
      describe "use let val" do
        let :result, do: 42

        it do: expect(result) |> to(eq 42)
      end

      describe "use let name in example" do
        it "is not okay" do
          result = 23
          expect(result) |> to(eq 23)
        end
      end

      describe "use let name in pattern match" do
        it "is not okay" do
          {:ok, result} = {:ok, 123} # this still fails
          expect(result) |> to(eq 123)
        end
      end
    end
  end

  setup_all do
    {:ok,
      ex1: Enum.at(SomeSpec.examples, 0),
      ex2: Enum.at(SomeSpec.examples, 1),
      ex3: Enum.at(SomeSpec.examples, 2),

      ex4: Enum.at(SomeSpec2.examples, 0),
      ex5: Enum.at(SomeSpec2.examples, 1),

      ex6: Enum.at(SomeSpec3.examples, 0),
      ex7: Enum.at(SomeSpec3.examples, 1),
      ex8: Enum.at(SomeSpec3.examples, 2),
    }
  end

  test "runs ex1 then ex2", context do
    example = ESpec.ExampleRunner.run(context[:ex1])
    assert example.status == :success

    example = ESpec.ExampleRunner.run(context[:ex2])
    assert example.status == :failure
    assert example.error.message =~ "The let function `a/0` is not defined in the current scope!"
  end

  test "runs ex1 then ex3", context do
    example = ESpec.ExampleRunner.run(context[:ex1])
    assert example.status == :success

    example = ESpec.ExampleRunner.run(context[:ex3])
    assert example.status == :failure
    assert example.error.message =~ "The let function `a/0` is not defined in the current scope!"
  end

  test "runs ex5 then ex4", context do
    example = ESpec.ExampleRunner.run(context[:ex5])
    assert example.status == :success

    example = ESpec.ExampleRunner.run(context[:ex4])
    assert example.status == :failure
    assert example.error.message =~ "The let function `a/0` is not defined in the current scope!"
  end

  test "runs ex6 then ex7 and ex8", context do
    example = ESpec.ExampleRunner.run(context[:ex6])
    assert example.status == :success

    example = ESpec.ExampleRunner.run(context[:ex7])
    assert example.status == :success

    example = ESpec.ExampleRunner.run(context[:ex8])
    assert example.status == :success
   end
end
