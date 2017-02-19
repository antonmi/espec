defmodule ESpec.CustomFormatter do
  use ESpec.Formatters.Base

  def init(opts) do
    IO.inspect("init with opts #{inspect opts}")
    {:ok, opts}
  end

  def handle_cast({:example_finished, example}, opts) do
    IO.inspect("example_finished: #{inspect example}")
    {:noreply, opts}
  end

  def handle_cast({:final_result, examples, _durations}, opts) do
    IO.inspect("final_result: #{inspect examples}")
    {:noreply, opts}
  end
end
