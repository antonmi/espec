defmodule ESpec do

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

  def run do
    examples = ESpec.Runner.run
    ESpec.Formatter.print_result(examples)
    !Enum.any?(ESpec.Example.failure(examples))
  end

  def start do
    {:ok, _} = Application.ensure_all_started(:espec)
    start_specs_agent
    ESpec.Assertions.init
    ESpec.Let.start_agent
    ESpec.Mock.start_agent
  end

  def register_assertions(assertions) do
    ESpec.Assertions.register(assertions)
  end

  def start_specs_agent do
    Agent.start_link(fn -> [] end, name: @spec_agent_name)
  end

  def specs do
    Agent.get(@spec_agent_name, &(&1))
  end

  def add_spec(module) do
    Agent.update(@spec_agent_name, &[module | &1])
  end

end
