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
		
			it "ESpec.SomeModule.m is defined" do
			  expect(ESpec.SomeModule.m).to eq(:m)
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
    example = ESpec.ExampleRunner.run(context[:ex1])
    assert(example.result == "mock! 1")
  end 

  test "run ex2", context do
    example = ESpec.ExampleRunner.run(context[:ex2])
    assert(example.result == :w)
  end 

  test "run ex3", context do
    example = ESpec.ExampleRunner.run(context[:ex3])
    assert(example.status == :success)
  end 

  test "run ex4", context do
    example = ESpec.ExampleRunner.run(context[:ex4])
    assert(example.status == :success)
  end

  test "run ex5", context do
    example = ESpec.ExampleRunner.run(context[:ex5])
    assert(example.status == :success)
  end

  test "run ex6", context do
    example = ESpec.ExampleRunner.run(context[:ex6])
    assert(example.result == :f)
  end
end