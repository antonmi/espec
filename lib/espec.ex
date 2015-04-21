defmodule ESpec do
  @moduledoc """
  The ESpec basic module. Imports a lot of ESpec components.
  One should `use` the module in spec modules.
  """

  @spec_agent_name :espec_specs_agent

  defmacro __using__(args) do
    quote do
      unquote(__MODULE__).add_spec(__MODULE__)

      import unquote(__MODULE__)

      Module.register_attribute __MODULE__, :examples, accumulate: true
      
      @shared unquote(args)[:shared] || false
      @async unquote(args)[:async] || false
      @before_compile unquote(__MODULE__)

      import ESpec.Context
      @context [%ESpec.Context{ description: inspect(__MODULE__), module: __MODULE__, line: __ENV__.line, opts: unquote(args) }]

      import ESpec.Example

      import ESpec.Expect
      use ESpec.Expect
      import ESpec.Should
      use ESpec.Should
    
      import ESpec.AssertionHelpers

      import ESpec.Allow

      import ESpec.Before
      import ESpec.Finally
      import ESpec.Let

    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def examples, do: Enum.reverse(@examples)
    end
  end

  def configure(func), do: ESpec.Configuration.configure(func)

  @doc "Runs the examples and prints results"
  def run do
    ESpec.Runner.start
    ESpec.Runner.run
  end

  @doc "Starts ESpec. Starts agents to store specs, mocks, cache 'let' values, etc."
  def start do
    {:ok, _} = Application.ensure_all_started(:espec)
    start_specs_agent
    ESpec.Let.start_agent
    ESpec.Mock.start_agent
    ESpec.Output.start
  end

  defp start_specs_agent do
    Agent.start_link(fn -> [] end, name: @spec_agent_name)
  end

  def specs do
    Agent.get(@spec_agent_name, &(&1))
  end

  def add_spec(module) do
    Agent.update(@spec_agent_name, &[module | &1])
  end

end
