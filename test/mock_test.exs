[{module, _ }] = Code.load_file("spec/support/some_module.ex")
IO.inspect Code.ensure_compiled(module)

defmodule MockTest do

	use ExUnit.Case

  defmodule SomeSpec do
    use ESpec

		context "with mock" do
			before do
				allow(ESpec.SomeModule).to accept(:f, fn(a) -> "mock! #{a}" end)
				allow(ESpec.SomeModule).to accept(x: fn -> :y end, q: fn -> :w end)
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

      context "expect accepted" do
        it do: expect(ESpec.SomeModule).to_not accepted(:f, [1])
        before do: ESpec.SomeModule.f(1)
        it do: expect(ESpec.SomeModule).to accepted(:f, [1])
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
      ex4: Enum.at(SomeSpec.examples, 3),
      ex5: Enum.at(SomeSpec.examples, 4),
      ex6: Enum.at(SomeSpec.examples, 5)
    }
  end

  test "check ESpec.SomeModule" do
    assert(ESpec.SomeModule.f == :f)
    assert(ESpec.SomeModule.m == :m)
  end

  test "run ex1", context do
    example = ESpec.Runner.run_example(context[:ex1])
    assert(example.result == "mock! 1")
  end 

  test "run ex2", context do
    example = ESpec.Runner.run_example(context[:ex2])
    assert(example.result == :w)
  end 

  test "run ex3", context do
    assert(ESpec.Runner.run_example(context[:ex3]).result == "rescued")
  end 

  test "run ex4", context do
    example = ESpec.Runner.run_example(context[:ex4])
    assert(example.status == :success)
  end

  test "run ex5", context do
    example = ESpec.Runner.run_example(context[:ex5])
    assert(example.status == :success)
  end

  test "run ex6", context do
    example = ESpec.Runner.run_example(context[:ex6])
    assert(example.result == :f)
  end
end