defmodule MockSpec do
  use ESpec

  import ESpec.TestHelpers

  defmodule SomeModule do
    def f, do: :f
    def m, do: :m
  end |> write_beam

  it do: expect(SomeModule.f).to eq(:f)

  context "with mock" do
    before do
      allow(SomeModule).to accept(:f, fn(a) -> "mock! #{a}" end)
      allow(SomeModule).to accept(x: fn -> :y end, q: fn -> :w end)
    end

    it do: expect(SomeModule.f(1)).to eq("mock! 1")
    it do: expect(SomeModule.q).to eq(:w)
    
    it "SomeModule.m is not mocked" do
      expect(SomeModule.m).to eq(:m)
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
 

end