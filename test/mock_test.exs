defmodule MockTest do
  use ExUnit.Case

  alias TestModules.Mocks.SomeModule

  defmodule SomeSpec do
    use ESpec

    context "with mock" do
      before do
        allow(TestModules.Mocks.SomeModule) |> to(accept(:f, fn a -> "mock! #{a}" end))
        allow(TestModules.Mocks.SomeModule) |> to(accept(x: fn -> :y end, q: fn -> :w end))
      end

      it do: apply(SomeModule, :f, [1])
      it do: apply(SomeModule, :q, [])

      it "SomeModule.m is defined" do
        expect(SomeModule.m()) |> to(eq(:m))
      end

      context "expect accepted" do
        it do: expect(SomeModule) |> to_not(accepted(:f, [1]))
        before do: apply(SomeModule, :f, [1])
        it do: expect(SomeModule) |> to(accepted(:f, [1]))
      end

      context "passthrough" do
        before do
          allow(SomeModule)
          |> to(
            accept(:f1, fn
              AAA -> "mock! AAA"
              _ -> passthrough([BBB])
            end)
          )
        end

        it do: expect(SomeModule.f1(AAA)) |> to(eq("mock! AAA"))
        it do: expect(SomeModule.f1(BBB)) |> to(eq(BBB))
      end
    end

    context "stubs" do
      before do
        allow(SomeModule) |> to(accept(:f))
        allow(SomeModule) |> to(accept([:x, :q]))
      end

      it do: expect(SomeModule.f()) |> to(be_nil())
      it do: expect(apply(SomeModule, :q, [10])) |> to(be_nil())
    end

    context "without mock" do
      it do: SomeModule.f()
    end
  end

  setup_all do
    {:ok,
     ex1: Enum.at(SomeSpec.examples(), 0),
     ex2: Enum.at(SomeSpec.examples(), 1),
     ex3: Enum.at(SomeSpec.examples(), 2),
     ex4: Enum.at(SomeSpec.examples(), 3),
     ex5: Enum.at(SomeSpec.examples(), 4),
     ex6: Enum.at(SomeSpec.examples(), 5),
     ex7: Enum.at(SomeSpec.examples(), 6),
     ex8: Enum.at(SomeSpec.examples(), 7),
     ex9: Enum.at(SomeSpec.examples(), 8),
     ex10: Enum.at(SomeSpec.examples(), 9)}
  end

  test "check SomeModule" do
    assert(SomeModule.f() == :f)
    assert(SomeModule.m() == :m)
  end

  test "run ex1", context do
    example = ESpec.ExampleRunner.run(context[:ex1])
    assert(example.result == "mock! 1")
  end

  test "run ex2", context do
    example = ESpec.ExampleRunner.run(context[:ex2])
    assert(example.result == :w)
  end

  test "run ex3", context do
    example = ESpec.ExampleRunner.run(context[:ex3])
    assert(example.status == :success)
  end

  test "run ex4", context do
    example = ESpec.ExampleRunner.run(context[:ex4])
    assert(example.status == :success)
  end

  test "run ex5", context do
    example = ESpec.ExampleRunner.run(context[:ex5])
    assert(example.status == :success)
  end

  test "run ex6", context do
    example = ESpec.ExampleRunner.run(context[:ex6])
    assert(example.result == "`\"mock! AAA\"` equals `\"mock! AAA\"`.")
    assert(example.status == :success)
  end

  test "run ex7", context do
    example = ESpec.ExampleRunner.run(context[:ex7])
    assert(example.result == "`BBB` equals `BBB`.")
    assert(example.status == :success)
  end

  test "run ex8", context do
    example = ESpec.ExampleRunner.run(context[:ex8])
    assert(example.result == "`nil` is nil.")
    assert(example.status == :success)
  end

  test "run ex9", context do
    example = ESpec.ExampleRunner.run(context[:ex9])
    assert(example.result == "`nil` is nil.")
    assert(example.status == :success)
  end

  test "run ex10", context do
    example = ESpec.ExampleRunner.run(context[:ex10])
    assert(example.result == :f)
  end
end
