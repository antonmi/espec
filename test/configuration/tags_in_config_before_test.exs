defmodule TagsInConfigBeforeTest do
  use ExUnit.Case, async: true

  ESpec.configure(fn config ->
    config.before(fn tags ->
      {:ok, %{answer: 42, tags: tags}}
    end)
  end)

  defmodule SomeSpec do
    use ESpec, async: false, some_tag: 1

    describe "tags in config before", another_tag: 2 do
      it do: expect(shared[:answer]) |> to(eq(42))

      let :tags, do: shared[:tags]

      it "passes tags to config before", example_tag: 3 do
        expect(tags().async) |> to(eq(false))
        expect(tags().some_tag) |> to(eq(1))
        expect(tags().another_tag) |> to(eq(2))
        expect(tags().example_tag) |> to(eq(3))
      end
    end
  end

  setup_all do
    {:ok, ex1: Enum.at(SomeSpec.examples(), 0), ex2: Enum.at(SomeSpec.examples(), 1)}
  end

  test "run ex1", context do
    example = ESpec.ExampleRunner.run(context[:ex1])
    assert(example.status == :success)
  end

  test "run ex2", context do
    example = ESpec.ExampleRunner.run(context[:ex2])
    assert(example.status == :success)
  end
end
