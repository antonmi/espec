defmodule ESpec.Assertions.PID.BeAliveSpec do
  require CheckErrorSharedSpec
  use ESpec, async: true

  context "Success" do
    it "checks success with `to`" do
      pid = self()
      message = expect(pid).to be_alive()
      expect(message) |> to(eq "`#{inspect(pid)}` is alive.")
    end

    it "checks success with `not_to`" do
      pid = spawn fn -> :ok end
      message = expect(pid).to_not be_alive()
      expect(message) |> to(eq "`#{inspect(pid)}` is not alive.")
    end
  end

  context "Errors" do
    context "with `to`" do
      before do
        pid = spawn fn -> :ok end
        {:shared,
          expectation: fn -> expect(pid).to be_alive() end,
          message: "Expected `#{inspect(pid)}` to be alive but it isn't."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end

    context "with `not_to`" do
      before do
        pid = self()
        {:shared,
          expectation: fn -> expect(pid).not_to be_alive() end,
          message: "Expected `#{inspect(pid)}` not to be alive but it is."}
      end

      it_behaves_like(CheckErrorSharedSpec)
    end
  end
end
