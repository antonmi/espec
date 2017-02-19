defmodule ESpec.Output do
  @moduledoc """
  Provides functions for output of spec results.
  Uses specified formatter to format results.
  """
  use GenServer
  alias ESpec.Configuration

  @doc "Starts server."
  def start do
    {:ok, gen_event_pid} = GenEvent.start_link([])
    GenServer.start_link(__MODULE__, %{formatters: formatters(), gen_event_pid: gen_event_pid}, name: __MODULE__)
  end

  @doc "Initiates server with configuration options and formatter"
  def init(args) do
    Enum.each(args[:formatters], fn({formatter_module, opts}) ->
      GenEvent.add_handler(args[:gen_event_pid], formatter_module, opts)
    end)
    state = %{opts: Configuration.all, formatter: args[:formatter], gen_event_pid: args[:gen_event_pid]}
    {:ok, state}
  end

  @doc "Generates example info."
  def example_info(example) do
    GenServer.cast(__MODULE__, {:example_info, example})
  end

  @doc "Generates suite info"
  def print_result(examples) do
   result = GenServer.call(__MODULE__, {:print_result, examples}, :infinity)
   result
  end

  @doc false
  def stop, do: GenServer.call(__MODULE__, :stop)

  @doc false
  def handle_cast({:example_info, example}, state) do
    unless silent?() do
      GenEvent.notify(state[:gen_event_pid], {:example_info, example})
    end
    {:noreply, state}
  end

  @doc false
  def handle_call({:print_result, examples}, _pid, state) do
    unless silent?() do
      GenEvent.notify(state[:gen_event_pid], {:print_result, examples, get_durations()})
    end
    {:reply, :ok, state}
  end

  @doc false
  def handle_call(:stop, _pid, state) do
    GenEvent.stop(state[:gen_event_pid])
    {:stop, :normal, :ok, []}
  end

  defp silent?, do: Configuration.get(:silent)

  defp formatters do
    case Configuration.get(:formatters) do
      nil -> [default_formatter()]
      [] -> [default_formatter()]
      formatters -> formatters
    end
  end

  defp default_formatter do
    if Configuration.get(:trace) do
      {ESpec.Formatters.Doc, %{details: true}}
    else
      {ESpec.Formatters.Doc, %{}}
    end
  end

  defp get_durations do
    {
      Configuration.get(:start_loading_time),
      Configuration.get(:finish_loading_time),
      Configuration.get(:finish_specs_time)
    }
  end
end
