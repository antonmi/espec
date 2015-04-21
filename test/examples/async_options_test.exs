defmodule AsyncOptionTest do

  use ExUnit.Case

  defmodule SomeSpecAsync do
    use ESpec, async: true

    it do: "async example 1"
    it do: "async example 2"
  end

  defmodule SomeSpecSyncAsync do
    use ESpec

    it do: "sync example 1"
    it do: "sync example 2"

    context "async context", async: true do
      it do: "async example 1"
    end

    it "async example 1", async: true do
      "async"
    end
  end

  test "check async examples in SomeSpecAsync" do
    {async, sync} = ESpec.Runner.partition_async(SomeSpecAsync.examples)
    assert length(async) == 2
    assert length(sync) == 0
  end

  test "check sync examples in SomeSpecSyncAsync" do
    {async, sync} = ESpec.Runner.partition_async(SomeSpecSyncAsync.examples)
    assert length(async) == 2
    assert length(sync) == 2
  end

end