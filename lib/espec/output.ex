defmodule ESpec.Output do
  @moduledoc """
  Provides functions for output of spec results.
  Uses specified formatter to format results.
  """
  use GenServer
  alias ESpec.Configuration

  @red IO.ANSI.red
  @reset IO.ANSI.reset

  @doc "Starts server."
  def start do
    GenServer.start_link(__MODULE__, %{formatters: formatters()}, name: __MODULE__)
  end

  @doc "Initiates server with configuration options and formatter"
  def init(args) do
    pids = Enum.map(args[:formatters], fn({formatter_module, opts}) ->
      {:ok, pid} = GenServer.start_link(formatter_module, opts)
      pid
    end)
    state = %{opts: Configuration.all, formatter: args[:formatter], formatter_pids: pids}
    {:ok, state}
  end

  @doc "Generates example info."
  def example_finished(example) do
    GenServer.cast(__MODULE__, {:example_finished, example})
  end

  @doc "Generates suite info"
  def final_result(examples) do
   result = GenServer.call(__MODULE__, {:final_result, examples}, :infinity)
   result
  end

  defp display_stop_timeout_message(timeout) do
    IO.puts "\n  #{@red}Sorry, but the formatters did not have enough time to finish their work."
    IO.puts "  The most time consuming are (most probably) the diffs in the Doc formatter (shown for the failed examples)."
    IO.puts "  You could try to:"
    IO.puts "  * run less (failed) examples (please see the doc on --exclude and --focus)"
    IO.puts "  * increase the formatters timeout (the current value is #{inspect(timeout)})"
    IO.puts "      \# spec_helper.exs"
    IO.puts "      ESpec.configure fn(config) ->"
    IO.puts "        config.formatters_timeout 30_000 \# or :infinity to wait until done"
    IO.puts "      end"
    IO.puts "  * disable the diffs for the Doc formatter"
    IO.puts "      \# spec_helper.exs"
    IO.puts "      ESpec.configure fn(config) ->"
    IO.puts "        config.formatters ["
    IO.puts "          \# ..."
    IO.puts "          {ESpec.Formatters.Doc, %{diff_enabled?: false}}"
    IO.puts "          \# ..."
    IO.puts "        ]"
    IO.puts "      end#{@reset}"
  end

  @doc false
  def stop do
    timeout = Configuration.get(:formatters_timeout)
    try do
      if is_nil(timeout) do
        GenServer.call(__MODULE__, :stop)
      else
        GenServer.call(__MODULE__, :stop, timeout)
      end
    catch
      :exit, {:timeout, {GenServer, :call, [ESpec.Output, :stop, timeout]}} = reason ->
        display_stop_timeout_message(timeout)
        exit(reason)
    end
  end

  @doc false
  def handle_cast({:example_finished, example}, state) do
    unless silent?() do
      Enum.each(state[:formatter_pids], &GenServer.cast(&1, {:example_finished, example}))
    end
    {:noreply, state}
  end

  @doc false
  def handle_call({:final_result, examples}, _pid, state) do
    unless silent?() do
      Enum.each(state[:formatter_pids], &GenServer.cast(&1, {:final_result, examples, get_durations()}))
    end
    {:reply, :ok, state}
  end

  @doc false
  def handle_call(:stop, _pid, state) do
    Enum.each(state[:formatter_pids], &GenServer.stop(&1))
    {:stop, :normal, :ok, []}
  end

  defp silent?, do: Configuration.get(:silent)

  defp formatters do
    case Configuration.get(:formatters) do
      nil -> [default_formatter()]
      [] -> [default_formatter()]
      list_of_formatters -> list_of_formatters
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
