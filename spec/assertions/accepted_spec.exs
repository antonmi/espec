defmodule AcceptedSpec do
  use ESpec

  import ESpec.TestHelpers

  defmodule SomeModule do
    def f, do: :f
    def m, do: :m
  end
  |> write_beam

  describe "expect(module).to accepted(func, args)" do
    before do
      allow(SomeModule) |> to(accept(:func, fn a, b -> a + b end))
      SomeModule.func(1, 2)
    end

    context "Success" do
      it "checks success with `to`" do
        message = expect(SomeModule) |> to(accepted(:func, [1, 2]))

        expect(message)
        |> to(
          eq "`AcceptedSpec.SomeModule` accepted `:func` with `[1, 2]` in process `:any` at least once."
        )
      end

      it "checks success with `not_to`" do
        message = expect(SomeModule) |> to_not(accepted(:another_function, []))

        expect(message)
        |> to(
          eq "`AcceptedSpec.SomeModule` didn't accept `:another_function` with `[]` in process `:any` at least once."
        )
      end
    end

    context "Error" do
      context "with `to`" do
        before do
          {:shared,
           expectation: fn -> expect(SomeModule) |> to(accepted(:another_function, [])) end,
           message:
             "Expected `AcceptedSpec.SomeModule` to accept `:another_function` with `[]` in process `:any` at least once, but it accepted the function `0` times."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end

      context "with `not_to`" do
        before do
          {:shared,
           expectation: fn -> expect(SomeModule) |> to_not(accepted(:func, [1, 2])) end,
           message:
             "Expected `AcceptedSpec.SomeModule` not to accept `:func` with `[1, 2]` in process `:any` at least once, but it accepted the function `1` times."}
        end

        it_behaves_like(CheckErrorSharedSpec)
      end
    end
  end

  describe "any args" do
    before do
      allow(SomeModule) |> to(accept(:func, fn a, b -> a + b end))
      SomeModule.func(1, 2)
      SomeModule.func(1, 2)
    end

    it do: expect(SomeModule) |> to(accepted(:func))
    it do: expect(SomeModule) |> to(accepted(:func, :any))
    it do: expect(SomeModule) |> to_not(accepted(:func, [2, 3]))
  end

  describe "count option" do
    before do
      allow(SomeModule) |> to(accept(:func, fn a, b -> a + b end))
      SomeModule.func(1, 2)
      SomeModule.func(1, 2)
    end

    it do: expect(SomeModule) |> to(accepted(:func, [1, 2], count: 2))
    it do: expect(SomeModule) |> to_not(accepted(:func, [1, 2], count: 1))
  end

  describe "pid option" do
    defmodule Server do
      def call(a, b) do
        SomeModule.func(a, b)
      end
    end

    before do
      allow(SomeModule) |> to(accept(:func, fn a, b -> a + b end))
      pid = spawn(Server, :call, [10, 20])
      :timer.sleep(100)
      {:ok, pid: pid}
    end

    it "accepted with pid" do
      expect(SomeModule) |> to(accepted(:func, [10, 20], pid: shared.pid))
    end

    it "not accepted with another pid" do
      expect(SomeModule) |> to_not(accepted(:func, [10, 20], pid: self()))
    end

    it "accepted with :any" do
      expect(SomeModule) |> to(accepted(:func, [10, 20], pid: :any))
    end

    context "with count" do
      before do
        allow(SomeModule) |> to(accept(:func, fn a, b -> a + b end))
        SomeModule.func(10, 20)
      end

      it do: expect(SomeModule) |> to(accepted(:func, [10, 20], pid: :any, count: 2))
    end
  end

  describe "messages" do
    import ESpec.Assertions.Accepted, only: [assert: 3]

    before do
      allow(SomeModule) |> to(accept(:func, fn a, b -> a + b end))
    end

    it "for positive assertions" do
      SomeModule.func(1, 2)

      expect(assert(SomeModule, [:func, :any, []], true)) |> to(
        eq(
          "`AcceptedSpec.SomeModule` accepted `:func` with `:any` in process `:any` at least once."
        )
      )

      expect(assert(SomeModule, [:func, [1, 2], [count: 1]], true)) |> to(
        eq(
          "`AcceptedSpec.SomeModule` accepted `:func` with `[1, 2]` in process `:any` `1` times."
        )
      )
    end

    it "for negative assertions" do
      expect(assert(SomeModule, [:func, :any, []], false)) |> to(
        eq(
          "`AcceptedSpec.SomeModule` didn't accept `:func` with `:any` in process `:any` at least once."
        )
      )

      expect(assert(SomeModule, [:func, [1, 2], [count: 1]], false)) |> to(
        eq(
          "`AcceptedSpec.SomeModule` didn't accept `:func` with `[1, 2]` in process `:any` `1` times."
        )
      )
    end

    it "for failed positive assertions" do
      expect(fn -> assert(SomeModule, [:func, :any, []], true) end) |> to(
        raise_exception(
          Elixir.ESpec.AssertionError,
          "Expected `AcceptedSpec.SomeModule` to accept `:func` with `:any` in process `:any` at least once, but it accepted the function `0` times."
        )
      )
    end

    it "for failed negative assertions" do
      SomeModule.func(1, 2)

      expect(fn -> assert(SomeModule, [:func, :any, []], false) end) |> to(
        raise_exception(
          Elixir.ESpec.AssertionError,
          "Expected `AcceptedSpec.SomeModule` not to accept `:func` with `:any` in process `:any` at least once, but it accepted the function `1` times."
        )
      )
    end
  end
end
