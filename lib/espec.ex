defmodule ESpec do

  @spec_agent_name :espec_specs_agent

  defmacro __using__(_arg) do
    quote do
      unquote(__MODULE__).add_spec(__MODULE__)

      import unquote(__MODULE__)

      Module.register_attribute __MODULE__, :examples, accumulate: true
      @context []

      @before_compile unquote(__MODULE__)

      import ESpec.Context
      import ESpec.Example

      import ESpec.Expect
      use ESpec.Expect

      import ESpec.Before
      import ESpec.Let

    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def examples, do: Enum.reverse(@examples)
      def run, do: ESpec.Runner.run_examples(@examples, __MODULE__)
    end
  end

  def run(opts) do
    ESpec.Runner.run(opts)
    |> ESpec.Formatter.print_result
  end

  def start do
    {:ok, _} = Application.ensure_all_started(:espec)
    start_specs_agent
    ESpec.Let.start_let_agent
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
