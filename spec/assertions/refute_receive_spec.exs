defmodule RefuteReceiveSpec do
  use ESpec, async: true

  describe "ESpec.Assertions.RefuteReceive" do
    context "Success" do
      it "refutes recieve with no message" do
        send(self, :another_hello)
        message = refute_receive :hello_refute
        expect(message) |> to(eq "Have not received `:hello_refute`.")
      end

      it "refutes recieved with no message" do
        send(self, :another_hello)
        message = refute_received :hello_refute
        expect(message) |> to(eq "Have not received `:hello_refute`.")
      end

      it "refutes recieved with unbound variable" do
        send(self, :another_hello)
        message = refute_received {_unbound, _variable}
        expect(message) |> to(eq "Have not received `{_unbound, _variable}`.")
      end

      it "refutes recieved with _" do
        send(self, :another_hello)
        message = refute_received {_, _}
        expect(message) |> to(eq "Have not received `{_, _}`.")
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

      it "refute received when message is in mailbox" do
        try do
          send(self, :hello_refute)
          refute_received _unbound
        rescue
          error in [ESpec.AssertionError] ->
            message = "Expected not to receive `_unbound`, but have received."
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
end
