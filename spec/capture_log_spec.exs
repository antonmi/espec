defmodule CaptureLogSpec do
  use ESpec
  require Logger

  before do: Application.start(:logger)

  let :message do
    capture_log(fn -> Logger.error "log msg" end)
  end

  it do: expect message |> to(match "log msg")

  context "with multiple concurrent captures" do
    let :fun do
      fn ->
        for msg <- ["hello", "hi"] do
          assert capture_log(fn -> Logger.error msg end) =~ msg
        end
        Logger.debug "testing"
      end
    end

    it do: expect capture_log(fun) |> to(match "hello")
    it do: expect capture_log(fun) |> to(match "testing")
  end
end
