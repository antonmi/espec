defmodule MockTest do

	use ExUnit.Case

  defmodule SomeSpec do
    use ESpec

		context "with mock" do
			before do
				allow(ESpec.SomeModule).to receive(:f, fn(a) -> "mock! #{a}" end)
				allow(ESpec.SomeModule).to receive_messages(x: fn -> :y end, q: fn -> :w end)
			end

			it do: ESpec.SomeModule.f(1)
			it do: ESpec.SomeModule.q
		
			it "ESpec.SomeModule.m is undefined" do
        try do
			   	ESpec.SomeModule.m
        rescue
          UndefinedFunctionError ->
            "rescued"
        end    
			end
		end

		context "without mock" do
			it do: ESpec.SomeModule.f
		end

  end

  setup_all do
    {:ok,
      ex1: Enum.at(SomeSpec.examples, 0),
      ex2: Enum.at(SomeSpec.examples, 1),
      ex3: Enum.at(SomeSpec.examples, 2),
      ex4: Enum.at(SomeSpec.examples, 3)
    }
  end

  test "run ex1", context do
    example = ESpec.Runner.run_example(context[:ex1], SomeSpec)
    assert(example.result == "mock! 1")
  end 

  test "run ex2", context do
    example = ESpec.Runner.run_example(context[:ex2], SomeSpec)
    assert(example.result == :w)
  end 

  test "run ex3", context do
    assert(ESpec.Runner.run_example(context[:ex3], SomeSpec).result == "rescued")
  end 

  test "run ex4", context do
    example = ESpec.Runner.run_example(context[:ex4], SomeSpec)
    assert(example.result == :f)
  end

end