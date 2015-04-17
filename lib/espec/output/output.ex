defmodule ESpec.Output do

  use GenServer

  def start do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    state = %{opts: ESpec.Configuration.all}
    {:ok, state}
  end

	def example_info(example), do: GenServer.cast(__MODULE__, {:example_info, example})
	def print_result(examples), do: GenServer.call(__MODULE__, {:print_result, examples})
  
  def handle_cast({:example_info, example}, state) do
		do_example_info(example)
		{:noreply, state}
	end

	def handle_call({:print_result, examples}, _pid, state) do
		
		do_print_result(examples)
		{:reply, :ok, state}
	end

	def do_example_info(example) do
   	ESpec.Output.Console.example_info(example)
  end

  def do_print_result(examples) do
  	ESpec.Output.Console.print_result(examples)
  end


end