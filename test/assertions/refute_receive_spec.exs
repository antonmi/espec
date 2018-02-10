defmodule AssertReceiveTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    context "Success" do
      it "refute_receive" do
        send(self(), :another_hello)
        ESpec.RefuteReceive.refute_receive(:hello_refute)
      end

      it "refute_received" do
        send(self(), :another_hello)
        ESpec.RefuteReceive.refute_received(:hello_refute)
      end
    end

    context "Errors" do
      it "refute_received" do
        send(self(), :hello_refute_1)
        ESpec.RefuteReceive.refute_received(:hello_refute_1)
      end
    end
  end

  setup_all do
    examples = ESpec.SuiteRunner.run_examples(SomeSpec.examples(), true)
    {:ok, success: Enum.slice(examples, 0, 1), errors: Enum.slice(examples, 2, 2)}
  end

  test "Success", context do
    Enum.each(context[:success], &assert(&1.status == :success))
  end

  test "Errors", context do
    Enum.each(context[:errors], &assert(&1.status == :failure))
  end
end
