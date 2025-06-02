defmodule AllowAcceptSpec do
  use ESpec

  defmodule SomeModule, do: ""

  describe "allow(module).to accept(name, func)" do
    before do: allow(SomeModule) |> to(accept(:func, fn a -> "mock! #{a}" end))

    it do: expect(apply(SomeModule, :func, [1])) |> to(eq "mock! 1")
  end

  describe "allow(module).to accept(name1: func1, name2: func2)" do
    before do
      allow(SomeModule)
      |> to(
        accept(
          func: fn a -> "mock! #{a}" end,
          func2: fn -> "mock! func2" end
        )
      )
    end

    it do: expect(apply(SomeModule, :func, [1])) |> to(eq "mock! 1")
    it do: expect(apply(SomeModule, :func2, [])) |> to(eq "mock! func2")
  end
end
