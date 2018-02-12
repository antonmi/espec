defmodule LetsWithBeforesSpec do
  use ESpec, async: true

  before do: {:ok, a: 1}
  it do: shared.a |> should(eq 1)

  let :b, do: shared.a + 1
  it do: b() |> should(eq 2)

  let! :c, do: b() + 1
  it do: c() |> should(eq 3)

  before do: {:ok, d: c() + 1}
  it do: shared.d |> should(eq 4)
end
