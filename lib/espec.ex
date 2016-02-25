defmodule ESpec do
  @moduledoc """
  The ESpec basic module. Imports a lot of ESpec components.
  One should `use` the module in spec modules.
  """

  @spec_agent_name :espec_specs_agent

  defmacro __using__(args) do
    quote do
      ESpec.add_spec(__MODULE__)

      Module.register_attribute __MODULE__, :examples, accumulate: true

      @shared unquote(args)[:shared] || false
      @before_compile ESpec

      import ESpec.Context
      @context [%ESpec.Context{ description: inspect(__MODULE__), module: __MODULE__, line: __ENV__.line, opts: unquote(args) }]

      import ESpec.ExampleHelpers
      import ESpec.DocTest, only: [doctest: 1, doctest: 2]

      import ESpec.Expect
      use ESpec.Expect
      import ESpec.To
      import ESpec.Should
      use ESpec.Should

      import ESpec.AssertionHelpers

      import ESpec.Allow

      import ESpec.Before
      import ESpec.Finally
      import ESpec.Let

      import ExUnit.CaptureIO
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def examples, do: Enum.reverse(@examples)
    end
  end

  @doc """
  Allows to set the config options.
  ESpec.configure(fn(config) ->
    config.key value
    config.another_key another_value
  end)
  """
  def configure(func), do: ESpec.Configuration.configure(func)

  @doc "Runs the examples"
  def run do
    ESpec.Runner.start
    ESpec.Runner.run
  end

  @doc "Starts ESpec. Starts agents to store specs, mocks, cache 'let' values, etc."
  def start do
    {:ok, _} = Application.ensure_all_started(:espec)
    start_specs_agent
    ESpec.Let.Impl.start_agent
    ESpec.Mock.start_agent
    ESpec.Output.start
  end

  @doc "Stops ESpec components"
  def stop do
    stop_specs_agent
    ESpec.Let.Impl.stop_agent
    ESpec.Mock.stop_agent
    ESpec.Runner.stop
    ESpec.Output.stop
  end

  @doc "Returns all examples."
  def specs, do: Agent.get(@spec_agent_name, &(&1))

  @doc "Adds example to the agent."
  def add_spec(module), do: Agent.update(@spec_agent_name, &[module | &1])

  defp start_specs_agent, do: Agent.start_link(fn -> [] end, name: @spec_agent_name)
  def stop_specs_agent, do: Agent.stop(@spec_agent_name)
end
