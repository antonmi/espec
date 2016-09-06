defmodule MockSpec do
  use ESpec

  import ESpec.TestHelpers

  defmodule SomeModule do
    def f, do: :f
    def m, do: :m

    def f1(a), do: a
    def f2(a, b), do: "#{a} and #{b}"
  end |> write_beam

  it do: expect(SomeModule.f).to eq(:f)

  context "with mock" do
    before do
      allow(SomeModule).to accept(:f, fn(a) -> "mock! #{a}" end)
      allow(SomeModule).to accept(x: fn -> :y end, q: fn -> :w end)
    end

    it do: expect(SomeModule.f(1)).to eq("mock! 1")
    it do: expect(SomeModule.x).to eq(:y)
    it do: expect(SomeModule.q).to eq(:w)

    it "SomeModule.m is not mocked" do
      expect(SomeModule.m).to eq(:m)
    end
  end

  context "with mock and new syntax" do
    before do
      allow SomeModule |> to(accept(:f, fn(a) -> "mock! #{a}" end))
      allow SomeModule |> to(accept(x: fn -> :y end, q: fn -> :w end))
    end

    it do: expect SomeModule.f(1) |> to(eq "mock! 1")
    it do: expect SomeModule.x |> to(eq :y)
    it do: expect SomeModule.q |> to(eq :w)

    it "SomeModule.m is not mocked" do
      expect SomeModule.m |> to(eq :m)
    end
  end


  context "stubs" do
    context "old syntax" do
      before do
        allow(SomeModule).to accept(:f)
        allow(SomeModule).to accept([:x, :q])
      end

      it do: expect(SomeModule.f).to be_nil()

      it do: expect(SomeModule.x).to be_nil()
      it do: expect(SomeModule.q(10)).to be_nil()
    end

    context "with new syntax" do
      before do
        allow SomeModule |> to(accept :f)
        allow SomeModule |> to(accept [:x, :q])
      end

      it do: expect SomeModule.f |> to(be_nil())

      it do: expect SomeModule.x |> to(be_nil())
      it do: expect SomeModule.q(10) |> to(be_nil())
    end
  end

  context "without mock" do
    it do: expect(SomeModule.f).to eq(:f)
  end

  context "mock in another process doesn't mock functions in current process" do
    before do
      spawn fn -> allow(SomeModule).to accept(:f, fn(a) -> "mock! #{a}" end) end
    end
    # it do: expect(SomeModule.f).to eq(:f)
  end

  context "passthrough" do
    context "old syntax" do
      before do
        allow(SomeModule).to accept(:f, fn
          :a -> "mock! :a"
          :b -> passthrough([])
        end)

        allow(SomeModule).to accept(:f1, fn
          AAA -> "mock! AAA"
          [AAA, BBB] -> "mock! AAA, BBB"
          _ -> passthrough([BBB])
        end)

        allow(SomeModule).to accept(:f2, fn
          AAA, BBB -> "mock! AAA BBB"
          a, b -> passthrough([a, b])
        end)
      end

      it do: expect(SomeModule.f(:a)).to eq("mock! :a")
      it do: expect(SomeModule.f(:b)).to eq(:f)

      it do: expect(SomeModule.f1(AAA)).to eq("mock! AAA")
      it do: expect(SomeModule.f1([AAA, BBB])).to eq("mock! AAA, BBB")
      it do: expect(SomeModule.f1(BBB)).to eq(BBB)

      it do: expect(SomeModule.f2(AAA, BBB)).to eq("mock! AAA BBB")
      it do: expect(SomeModule.f2(10, 20)).to eq("10 and 20")
    end

    context "new syntax" do
      before do
        allow SomeModule |> to(accept(:f, fn
          :a -> "mock! :a"
          :b -> passthrough([])
        end))

        allow SomeModule |> to(accept(:f1, fn
          AAA -> "mock! AAA"
          [AAA, BBB] -> "mock! AAA, BBB"
          _ -> passthrough([BBB])
        end))

        allow SomeModule |> to(accept(:f2, fn
          AAA, BBB -> "mock! AAA BBB"
          a, b -> passthrough([a, b])
        end))
      end

      it do: expect SomeModule.f(:a) |> to(eq "mock! :a")
      it do: expect SomeModule.f(:b) |> to(eq :f)

      it do: expect SomeModule.f1(AAA) |> to(eq "mock! AAA")
      it do: expect SomeModule.f1([AAA, BBB]) |> to(eq "mock! AAA, BBB")
      it do: expect SomeModule.f1(BBB) |> to(eq BBB)

      it do: expect SomeModule.f2(AAA, BBB) |> to(eq "mock! AAA BBB")
      it do: expect SomeModule.f2(10, 20) |> to(eq "10 and 20")
    end
  end

  context "custom meck options" do
    context "old syntax" do
      context "one function" do
        before do
          allow(SomeModule).to accept(:f, fn(a) -> "mock! #{a}" end, [:non_strict, :unstick])
        end
        it do: expect(SomeModule.f(10)).to eq("mock! 10")
      end

      context "list of functions" do
        before do
          allow(SomeModule).to accept(
            [x: fn -> :y end, q: fn -> :w end],
            [:non_strict, :passthrough]
          )
        end
        it do: expect(SomeModule.x).to eq(:y)
        it do: expect(SomeModule.q).to eq(:w)
      end
    end

    context "new syntax" do
      context "one function" do
        before do
          allow SomeModule |> to(accept :f, fn(a) -> "mock! #{a}" end, [:non_strict, :unstick])
        end
        it do: expect SomeModule.f(10) |> to(eq "mock! 10")
      end

      context "list of functions" do
        before do
          allow SomeModule |> to(accept(
            [x: fn -> :y end, q: fn -> :w end],
            [:non_strict, :passthrough]
          ))
        end
        it do: expect SomeModule.x |> to(eq :y)
        it do: expect SomeModule.q |> to(eq :w)
      end
    end
  end
end
