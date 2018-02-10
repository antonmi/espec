defmodule BeforeAndAfterAllSpec do
  use ESpec

  before_all do: Application.put_env(:espec, :before_all, "hello")

  let :value, do: Application.get_env(:espec, :before_all)

  it do: expect(value()) |> to(eq "hello")
end
