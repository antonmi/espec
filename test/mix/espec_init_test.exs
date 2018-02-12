defmodule EspecInitTest do
  use ExUnit.Case

  @tmp_path Path.join(__DIR__, "tmp")

  def clear, do: File.rm_rf!(@tmp_path)

  setup do
    # Get Mix output sent to the current process to avoid polluting tests.
    Mix.shell(Mix.Shell.Process)
    File.mkdir_p!(@tmp_path)
    File.cd!(@tmp_path, fn -> Mix.Tasks.Espec.Init.run([]) end)
    on_exit(&clear/0)
    :ok
  end

  test "check spec_helper exists" do
    assert File.regular?(Path.join(@tmp_path, "spec/spec_helper.exs"))
  end

  test "spec_helper content" do
    {:ok, content} = File.read(Path.join(@tmp_path, "spec/spec_helper.exs"))
    assert content =~ "ESpec.config"
  end

  test "check shared example spec exists" do
    assert File.regular?(Path.join(@tmp_path, "spec/shared/example_spec.exs"))
  end

  test "shared/example_spec.exs content" do
    {:ok, content} = File.read(Path.join(@tmp_path, "spec/shared/example_spec.exs"))
    assert content =~ "defmodule ExampleSharedSpec do"
    assert content =~ "use ESpec, shared: true"
  end
end
