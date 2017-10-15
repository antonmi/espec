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
      pid = spawn fn -> 1 + 2 end
      message = expect(pid).to_not be_alive()
      expect(message) |> to(eq "`#{inspect(pid)}` is not alive.")
    end
  end

  # context "Errors" do
  #   context "with `to`" do
  #     before do
  #       {:shared,
  #         expectation: fn -> expect(true).to be_false() end,
  #         message: "Expected `true` to be false but it isn't."}
  #     end
  #
  #     it_behaves_like(CheckErrorSharedSpec)
  #   end
  #
  #   context "with `not_to`" do
  #     before do
  #       {:shared,
  #         expectation: fn -> expect(false).not_to be_false() end,
  #         message: "Expected `false` not to be false but it is."}
  #     end
  #
  #     it_behaves_like(CheckErrorSharedSpec)
  #   end
  # end
end
