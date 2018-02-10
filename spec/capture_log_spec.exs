defmodule CaptureLogSpec do
  use ESpec
  require Logger

  before do: Application.start(:logger)

  let :message do
    capture_log(fn -> Logger.error("log msg") end)
  end

  if Code.ensure_loaded?(ExUnit.CaptureServer) do
    it "has 'log msg' message" do
      expect(message() |> to(match("log msg")))
      :ok
    end

    context "with multiple concurrent captures" do
      let :fun do
        fn ->
          for msg <- ["hello", "hi"] do
            assert capture_log(fn -> Logger.error(msg) end) =~ msg
          end

          Logger.debug("testing")
        end
      end

      it "has 'hello' in logs" do
        expect(capture_log(fun()) |> to(match("hello")))
        :ok
      end

      it "has 'testing' in logs" do
        expect(capture_log(fun()) |> to(match("testing")))
        :ok
      end
    end
  end
end
