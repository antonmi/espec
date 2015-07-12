defmodule ESpec.Output do
  @moduledoc """
  Provides functions for output of spec results.
  Uses specified formatter to format results.
  """
  use GenServer

  @doc "Starts server."
  def start do
    GenServer.start_link(__MODULE__, [formatter: formatter], name: __MODULE__)
  end

  @doc "Initiates server with configuration options and formatter"
  def init(args) do
    if output_to_file?, do: create_out_file!
    state = %{opts: ESpec.Configuration.all, formatter: args[:formatter]}
    {:ok, state}
  end

  @doc "Generates example info."
  def example_info(example), do: GenServer.cast(__MODULE__, {:example_info, example})
  
  @doc "Generates suite info"
  def print_result(examples) do
   result = GenServer.call(__MODULE__, {:print_result, examples})
   if output_to_file?, do: close_out_file
   result
  end
  
  @doc false
  def handle_cast({:example_info, example}, state) do
    do_example_info(example, state[:formatter])
    {:noreply, state}
  end

  @doc false
  def handle_call({:print_result, examples}, _pid, state) do
    do_print_result(examples, state[:formatter])
    {:reply, :ok, state}
  end

  @doc false
  def do_example_info(example, {formatter, opts}) do
    unless silent? do
      if output_to_file? do
        IO.write out_file, formatter.format_example(example, opts)
      else
        IO.write formatter.format_example(example, opts)
      end
    end
  end

  @doc false
  def do_print_result(examples, {formatter, opts}) do
    unless silent? do
      if output_to_file? do
        IO.write out_file, formatter.format_result(examples, get_times, opts)
      else
        IO.write formatter.format_result(examples, get_times, opts)
      end
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

  defp output_to_file?, do: out_path
 
  defp create_out_file! do
    File.mkdir_p!(Path.dirname(out_path))
    {:ok, file} = File.open(out_path, [:write])
    ESpec.Configuration.add([out_file: file])
  end

  defp close_out_file, do: File.close(out_file)
  
  defp out_file, do: ESpec.Configuration.get(:out_file)
  defp out_path, do: ESpec.Configuration.get(:out)

  defp get_times do
    {
      ESpec.Configuration.get(:start_loading_time),
      ESpec.Configuration.get(:finish_loading_time),
      ESpec.Configuration.get(:finish_specs_time)
    }
  end
end
