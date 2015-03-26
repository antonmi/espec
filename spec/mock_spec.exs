defmodule MockSpec do

	use ESpec

  it do: expect(ESpec.SomeModule.f).to eq(:f)

	context "with mock" do
		before do
			allow(ESpec.SomeModule).to receive(:f, fn(a) -> "mock! #{a}" end)
			allow(ESpec.SomeModule).to receive_messages(x: fn -> :y end, q: fn -> :w end)
		end

		it do: expect(ESpec.SomeModule.f(1)).to eq("mock! 1")
		it do: expect(ESpec.SomeModule.q).to eq(:w)
		
		it "ESpec.SomeModule.m is undefined" do
			expect(&ESpec.SomeModule.m/0).to raise_exception(UndefinedFunctionError)
		end
	end

	context "without mock" do
		it do: expect(ESpec.SomeModule.f).to eq(:f)
	end

end
