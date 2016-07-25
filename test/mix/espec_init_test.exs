defmodule EspecInitTest do
  use ExUnit.Case

  @tmp_path Path.join(__DIR__, "tmp")

  def clear, do: File.rm_rf! @tmp_path

  setup context do
    Mix.shell(Mix.Shell.Process) # Get Mix output sent to the current process to avoid polluting tests.
    function = if context[:skip_examples] do
      fn -> Mix.Tasks.Espec.Init.run(["--skip-examples"]) end
    else
      fn -> Mix.Tasks.Espec.Init.run([]) end
    end
    File.mkdir_p! @tmp_path
    File.cd! @tmp_path, function
    on_exit(&clear/0)
    :ok
  end

  test "check files" do
    assert File.regular?(Path.join(@tmp_path, "spec/spec_helper.exs"))
  end

  test "spec_helper content" do
    {:ok, content} = File.read(Path.join(@tmp_path, "spec/spec_helper.exs"))
    assert content =~ "ESpec.config"
  end
end
