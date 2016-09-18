defmodule TheSpecModule do
  def test, do: :test
end |> ESpec.TestHelpers.write_beam

defmodule TheSpecModuleSpec do
  use ESpec

  it do: expect @described_module |> to(eq Elixir.TheSpecModule)
  it do: expect described_module() |> to(eq Elixir.TheSpecModule)
  it do: expect described_module().test |> to(eq :test)
end
