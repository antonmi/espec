defmodule BeforeAndAfterAllTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    before_all do
      Application.put_env(:espec, :before_all, "hello")
    end

    it "checks before_all" do
      value = Application.get_env(:espec, :before_all)
      expect(value) |> to(eq "hello")
    end

    after_all do
      Application.put_env(:espec, :after_all, "world")
    end
  end

  setup_all do
    ESpec.Runner.Queue.start(:input)
    ESpec.Runner.Queue.start(:output)
    :ok
  end

  test "run ex1" do
    examples = ESpec.SuiteRunner.run(SomeSpec, %{}, false)
    assert(hd(examples).status == :success)
  end

  test "checks after_all" do
    ESpec.SuiteRunner.run(SomeSpec, %{}, false)
    assert Application.get_env(:espec, :after_all) == "world"
  end
end
