defmodule AcceptedTest do
  use ExUnit.Case
  import ExUnit.TestHelpers

  defmodule SomeModule do
    def f, do: :f
    def m, do: :m
  end |> write_beam

  defmodule SomeSpec do
    use ESpec

    ESpec.Context.describe "function call in another process" do
      defmodule Server do
        def call(a, b), do: SomeModule.func(a, b)
      end

      before do
        allow(SomeModule).to accept(:func, fn(a, b) -> a + b end)
        pid = spawn(Server, :call, [10, 20])
        :timer.sleep(100)
        {:ok, pid: pid}
      end

      it "accepted with pid" do
        expect(SomeModule).to accepted(:func, [10, 20], pid: shared.pid)
      end

      it "not accepted with another pid" do
        expect(SomeModule).to_not accepted(:func, [10, 20], pid: self())
      end

      it "accepted with :any" do
        expect(SomeModule).to accepted(:func, [10, 20], pid: :any)
      end
    end

    ESpec.Context.describe "count option" do
      before do
        allow(SomeModule).to accept(:func, fn(a, b) -> a + b end)
        SomeModule.func(1, 2)
        SomeModule.func(1, 2)
      end

      it do: expect(SomeModule).to accepted(:func, [1, 2], count: 2)
      it do: expect(SomeModule).to_not accepted(:func, [1, 2], count: 1)
    end

    ESpec.Context.describe "any args" do
      before do
        allow(SomeModule).to accept(:func, fn(a, b) -> a + b end)
        SomeModule.func(1, 2)
      end

      it do: expect(SomeModule).to accepted(:func)
      it do: expect(SomeModule).to accepted(:func, :any)
    end
  end

  setup_all do
    examples = ESpec.SuiteRunner.run_examples(SomeSpec.examples, true)
    {:ok, success: Enum.slice(examples, 0, 6)}
  end

  test "Success", context do
    Enum.each(context[:success], &(assert(&1.status == :success)))
  end
end
