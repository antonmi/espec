defmodule SharedSpec do
  use ESpec, shared: true, async: true

  before do: {:ok, c: shared.b + 1}
  finally do
     unless shared[:c] == 3, do: raise "Error"
  end

  let! :c, do: shared.c

  context "SharedSpec context" do
    let :d, do: shared.c + 1

    it do: expect shared.a |> to(eq 1)
    it do: expect shared.b |> to(eq 2)
    it do: expect c() |> to(eq 3)
    it do: expect d() |> to(eq 4)
  end

  describe "let use let" do
    let :a, do: shared.a
    let :b, do: a() + 1

    it do: b() |> should(eq 2)
  end

  describe "let and let form outer module" do
    it do: shared.outer_let() |> should(eq :outer_let)
    it do: shared.outer_let!() |> should(eq :outer_let!)
  end
end

defmodule UseSharedSpecSpec do
  use ESpec

  let! :outer_let!, do: :outer_let!
  let :outer_let, do: :outer_let

  before do
    {:shared,
      a: 1,
      outer_let!: outer_let!(),
      outer_let: outer_let()
    }
  end

  finally do
    unless shared[:c] == 3, do: raise "Error"
  end

  context "SomeSpec context" do
    before do: {:ok, b: 2}

    it_behaves_like(SharedSpec)
    include_examples(SharedSpec)
  end
end
