defmodule AssertReceiveSpec do
  use ESpec, async: true

  describe "ESpec.Assertions.AssertReceive" do
    context "Success" do
      it "waits until received" do
        parent = self()
        spawn(fn -> send parent, :hello end)
        message = assert_receive :hello
        expect(message) |> to(eq "Received `:hello`.")
      end

      it "waits custom time until received" do
        parent = self()
        spawn(fn -> :timer.sleep(200); send(parent, :hello) end)
        message = assert_receive(:hello, 300)
        expect(message) |> to(eq "Received `:hello`.")
      end

      it "does not wait when assert_received" do
        send(self(), :hello)
        message = assert_received :hello
        expect(message) |> to(eq "Received `:hello`.")
      end

      it "checks all the inbox" do
        for i <- 1..20, do: send(self, {:message, i})
        send(self(), :hello)
        message = assert_received :hello
        expect(message) |> to(eq "Received `:hello`.")
      end

      @received :hello

      it "receives with module attribute" do
        send(self(), :hello)
        message = assert_received @received
        expect(message) |> to(eq "Received `:hello`.")
      end

      it "receives with pinned variable" do
        world = :world
        send(self(), {:hello, :world})
        message = assert_received {:hello, ^world}
        expect(message) |> to(eq "Received `{:hello, :world}`.")
      end

      it "receives with multiple identical pinned variable" do
        world = :world
        send(self(), {:hello, :world, :world, :world})
        message = assert_received {:hello, ^world, ^world, ^world}
        expect(message) |> to(eq "Received `{:hello, :world, :world, :world}`.")
      end

      it "receives with multiple unique pinned variable" do
        awesome = :awesome
        world = :world
        send(self(), {:hello, :awesome, :world})
        message = assert_received {:hello, ^awesome, ^world}
        expect(message) |> to(eq "Received `{:hello, :awesome, :world}`.")
      end

      it "assert_received with guard expression" do
        send(self(), {:hello, :world})
        guard_world = :world
        message = assert_received {:hello, world} when world == guard_world
        expect(message) |> to(eq "Received `{:hello, :world}`.")
      end
    end

    context "Errors" do
      it "assert received when empty mailbox" do
        try do
          assert_received :hello
        rescue
          error in [ESpec.AssertionError] ->
            message = "Expected to receive `\":hello\"` but it doesn't.\n\tPinned variables: []\n\tProcess mailbox:\n\t"
            expect(error.message) |> to(eq message)
        end
      end

      it "assert received when different message" do
        try do
          send(self(), :another_message)
          assert_received :hello
        rescue
          error in [ESpec.AssertionError] ->
            message = "Expected to receive `\":hello\"` but it doesn't.\n\tPinned variables: []\n\tProcess mailbox:\n\t:another_message"
            expect(error.message) |> to(eq message)
        end
      end
    end
  end
end
