defmodule FinallySpec do
  use ESpec, async: true

  before do: {:ok, a: 1}
  finally do: "a = #{shared[:a]}"

  it do: expect(shared[:a] |> to(eq 1))
end
