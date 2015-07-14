defmodule Output.JsonTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    it do: expect(1).to eq(1)
    it do: expect(1).to eq(2)
    xit do: expect(1).to eq(1)
  end

  setup_all do
    examples = ESpec.Runner.run_examples(SomeSpec.examples)
    {:ok,
      examples: examples,
      success_example: Enum.at(examples, 0),
      failed_example: Enum.at(examples, 1),
      pending_example: Enum.at(examples, 2)
    }
  end

  @result_json "{\"examples\":[{\"decription\":\"Output.JsonTest.SomeSpec Output.JsonTest.SomeSpec\",\"file_line\":\"/home/antonmi/elixir/espec/test/output/json_test.exs:9\",\"status\":\"pending\",\"info\":\"Temporarily skipped with: `xit`.\"},{\"decription\":\"Output.JsonTest.SomeSpec Output.JsonTest.SomeSpec\",\"file_line\":\"/home/antonmi/elixir/espec/test/output/json_test.exs:8\",\"status\":\"failure\",\"info\":\"Expected `1` to equals (==) `2`, but it doesn't.\"},{\"decription\":\"Output.JsonTest.SomeSpec Output.JsonTest.SomeSpec\",\"file_line\":\"/home/antonmi/elixir/espec/test/output/json_test.exs:7\",\"status\":\"success\",\"info\":\"`1` equals `1`.\"}],\"summary\":{\"example_count\":3,\"failure_count\":1,\"pending_count\":1,\"duration\":0.0,\"load_time\":0.0,\"spec_time\":0.0}}"

  test "format_result", context do
    times = {{1436, 865768, 500000}, {1436, 865768, 500100}, {1436, 865768, 500200}}
    output = ESpec.Output.Json.format_result(context[:examples], times, %{})
    assert output == @result_json
  end
end
