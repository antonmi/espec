defmodule ESpec.CustomFormatter do
  use ESpec.Formatters.Base

  def init(opts) do
    IO.inspect("init with opts #{inspect opts}")
    {:ok, opts}
  end

  def handle_event({:example_finished, example}, opts) do
    IO.inspect("example_finished: #{inspect example}")
    {:ok, opts}
  end

  def handle_event({:final_result, examples, _durations}, opts) do
    IO.inspect("final_result: #{inspect examples}")
    {:ok, opts}
  end
end
