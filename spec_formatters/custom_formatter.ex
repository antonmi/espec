defmodule ESpec.CustomFormatter do
  use ESpec.Formatters.Base

  def init(opts) do
    IO.inspect("init with opts #{inspect opts}")
    {:ok, opts}
  end

  def handle_event({:example_info, example}, opts) do
    IO.inspect("expample_info: #{inspect example}")
    {:ok, opts}
  end

  def handle_event({:print_result, examples, _durations}, opts) do
    IO.inspect("print_result: #{inspect examples}")
    {:ok, opts}
  end
end
