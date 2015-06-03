defmodule ESpec.Output do

  use GenServer

  def start do
    GenServer.start_link(__MODULE__, [formatter: formatter], name: __MODULE__)
  end

  def init(args) do
    state = %{opts: ESpec.Configuration.all, formatter: args[:formatter]}
    {:ok, state}
  end

  def example_info(example), do: GenServer.cast(__MODULE__, {:example_info, example})
  def print_result(examples), do: GenServer.call(__MODULE__, {:print_result, examples})
  
  def handle_cast({:example_info, example}, state) do
    do_example_info(example, state[:formatter])
    {:noreply, state}
  end

  def handle_call({:print_result, examples}, _pid, state) do
    do_print_result(examples, state[:formatter])
    {:reply, :ok, state}
  end

  def do_example_info(example, {formatter, opts}) do
    unless silent? do
      IO.write formatter.format_example(example, opts)
    end
  end

  def do_print_result(examples, {formatter, opts}) do
    unless silent? do
      IO.write formatter.format_result(examples, get_times, opts)
    end
  end

  defp silent?, do: ESpec.Configuration.get(:silent)

  defp formatter do
    format = ESpec.Configuration.get(:format)
    if ESpec.Configuration.get(:trace), do: format = "doc"
    cond do
      format == "doc" ->
        {ESpec.Output.Docs, %{details: true}}
      true ->
        {ESpec.Output.Docs, %{}}
    end
  end

  def destination, do: :console

  defp get_times do
    {
      ESpec.Configuration.get(:start_loading_time),
      ESpec.Configuration.get(:finish_loading_time),
      ESpec.Configuration.get(:finish_specs_time)
    }
  end

end