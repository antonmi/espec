defmodule ESpec.DescribedModuleTest do
  use ExUnit.Case, async: true

  defmodule TheSpecModule do
    def test, do: :test
  end
  |> ExUnit.TestHelpers.write_beam()

  defmodule TheSpecModuleSpec do
    use ESpec
  end

  test ".described_module" do
    assert TheSpecModuleSpec.described_module() == TheSpecModule
    assert TheSpecModuleSpec.described_module().test == :test
  end
end
