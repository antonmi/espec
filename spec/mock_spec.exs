defmodule MockSpec do
  use ESpec

  it do: expect(ESpec.SomeModule.f).to eq(:f)

  context "with mock" do
    before do
      allow(ESpec.SomeModule).to accept(:f, fn(a) -> "mock! #{a}" end)
      allow(ESpec.SomeModule).to accept(x: fn -> :y end, q: fn -> :w end)
    end

    it do: expect(ESpec.SomeModule.f(1)).to eq("mock! 1")
    it do: expect(ESpec.SomeModule.q).to eq(:w)
		
    it "ESpec.SomeModule.m is not mocked" do
      expect(ESpec.SomeModule.m).to eq(:m)
    end
  end

  context "without mock" do
    it do: expect(ESpec.SomeModule.f).to eq(:f)
  end

  context "mock in another process doesn't mock functions in current process" do
    before do
      spawn fn -> allow(ESpec.SomeModule).to accept(:f, fn(a) -> "mock! #{a}" end) end
    end

    # it do: expect(ESpec.SomeModule.f).to eq(:f)
  end
 

end