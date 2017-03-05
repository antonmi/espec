defmodule GeneratedExamplesTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    Enum.map 1..3, fn(idx) ->
      it "fails, same name" do
        expect(unquote(idx)) |> to(eq(0))
      end

      it "fails, different name #{idx}" do
        expect(unquote(idx)) |> to(eq(-1))
      end
    end
  end

  setup_all do
    ESpec.Runner.Queue.start(:input)
    ESpec.Runner.Queue.start(:output)
    :ok
  end

  test "runs all of them and they fail with the appropriate message" do
    examples = ESpec.SuiteRunner.run(SomeSpec, %{}, false)

    assert(Enum.map(examples, fn(e) -> e.error.message end) ==
      Enum.map(3..1, fn(idx) ->
        ["Expected (==) `-1`, but got: `#{idx}`",
         "Expected (==) `0`, but got: `#{idx}`"]
      end)
      |> List.flatten)
  end
end
