defmodule ESpec.Let do
  @moduledoc """
  Defines 'let', 'let!' and 'subject' macrsos.
  'let' and 'let!' macros define named functions with cached return values.
  The 'let' evaluate block in runtime when called first time.
  The 'let!' evaluates as a before block just after all 'befores' for example.
  The 'subject' macro is just an alias for let to define `subject`.
  """

  @doc "Struct keeps the name of variable and random function name."
  defstruct var: nil, module: nil, function: nil

  @doc """
  The macro defines funtion with random name which returns block value.
  That function will be called when example is run.
  The function will place the block value to the Agent dict.
  """
  defmacro let(var, do: block) do
    function = ESpec.Let.Impl.random_let_name

    quote do
      tail = @context
      head = %ESpec.Let{var: unquote(var), module: __MODULE__, function: unquote(function)}

      def unquote(function)(var!(shared)) do
        var!(shared)
        unquote(block)
      end

      @context [head | tail]

      unless Module.defines?(__MODULE__, {unquote(var), 0}, :def) do
        def unquote(var)() do
          ESpec.Let.Impl.let_eval(__MODULE__, unquote(var))
        end
      end
    end
  end

  @doc "let! evaluate block like `before`"
  defmacro let!(var, do: block) do
    quote do
      let unquote(var), do: unquote(block)
      before do: unquote(var)()
    end
  end

  @doc "Defines 'subject'."
  defmacro subject(do: block) do
    quote do: let(:subject, do: unquote(block))
  end

  @doc "Defines 'subject'."
  defmacro subject(var) do
    quote do: let(:subject, do: unquote(var))
  end

  @doc "Defines 'subject!'."
  defmacro subject!(do: block) do
    quote do: let!(:subject, do: unquote(block))
  end

  @doc "Defines 'subject!'."
  defmacro subject!(var) do
    quote do: let!(:subject, do: unquote(var))
  end

  @doc """
  Defines 'subject' with name.
  It is just an alias for 'let'.
  """
  defmacro subject(var, do: block) do
    quote do: let(unquote(var), do: unquote(block))
  end

  @doc """
  Defines 'subject!' with name.
  It is just an alias for 'let!'.
  """
  defmacro subject!(var, do: block) do
    quote do: let!(unquote(var), do: unquote(block))
  end

  defmodule Impl do
    @agent_name :espec_let_agent

    @doc "This function is used by the let macro to implement lazy evaluation"
    def let_eval(module, var) do
      case agent_get({self, module, var}) do
        {:todo, funcname} ->
          shared = agent_get({self, :shared})
          result = apply(module, funcname, [shared])
          agent_put({self, module, var}, {:done, result})
          result
        {:done, result} ->
          result
      end
    end

    @doc "Starts Agent to save state of 'lets'."
    def start_agent, do: Agent.start_link(fn -> Map.new end, name: @agent_name)

    @doc "Stops Agent"
    def stop_agent, do: Agent.stop(@agent_name)

    @doc "Resets stored let value and prepares for evaluation. Called by ExampleRunner."
    def run_before(let) do
      agent_put({self, let.module, let.var}, {:todo, let.function})
    end

    @doc "Updates the shared map that is available to let blocks. Called by ExampleRunner."
    def update_shared(shared) do
      agent_put({self, :shared}, shared)
    end

    defp agent_get(key) do
      dict = Agent.get(@agent_name, &(&1))
      Map.get(dict, key)
    end

    defp agent_put(key, value), do: Agent.update(@agent_name, &(Map.put(&1, key, value)))

    def random_let_name, do: String.to_atom("let_#{ESpec.Support.random_string}")
  end
end
