defmodule AssertReceiveTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    context "Success" do
      it "assert_receive" do
        parent = self()
        spawn(fn -> send parent, :hello end)
        ESpec.AssertReceive.assert_receive :hello
      end

      it "assert_received" do
        send(self(), :hello)
        ESpec.AssertReceive.assert_received :hello
      end
    end

    context "Errors" do
      it "refute received when message is in mailbox" do
        try do
          send(self, :hello_refute)
          refute_received :hello_refute
        rescue
          error in [ESpec.AssertionError] ->
            message = "Expected not to receive `:hello_refute`, but have received."
            expect(error.message) |> to(eq message)
        end
      end

      it "refute received when message is somewhere in mailbox" do
        try do
          for i <- 1..10, do: send(self, {:message, i})
          send(self, :hello_refute)
          for i <- 1..10, do: send(self, {:message, i})
          refute_received :hello_refute
        rescue
          error in [ESpec.AssertionError] ->
            message = "Expected not to receive `:hello_refute`, but have received."
            expect(error.message) |> to(eq message)
        end
      end
    end
  end

  setup_all do
    examples = ESpec.Runner.run_examples(SomeSpec.examples, true)
    {:ok,
      success: Enum.slice(examples, 0, 1),
      errors: Enum.slice(examples, 2, 3)}
  end

  test "Success", context do
    Enum.each(context[:success], &(assert(&1.status == :success)))
  end

  test "Errors", context do
    Enum.each(context[:errors], &(assert(&1.status == :failure)))
  end
end
