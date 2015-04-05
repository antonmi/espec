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
      @context []
      @shared unquote(args)[:shared]
      @before_compile unquote(__MODULE__)

      import ESpec.Context
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
    examples = ESpec.Runner.run
    ESpec.Formatter.print_result(examples)
    !Enum.any?(ESpec.Example.failure(examples))
  end

  @doc "Starts ESpec. Starts agents to store specs, mocks, cache 'let' values, etc."
  def start do
    {:ok, _} = Application.ensure_all_started(:espec)
    ESpec.Assertions.init
    start_specs_agent
    ESpec.Let.start_agent
    ESpec.Mock.start_agent
  end

  @doc "Register custom assertions"
  def register_assertions(assertions) do
    ESpec.Assertions.register(assertions)
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
