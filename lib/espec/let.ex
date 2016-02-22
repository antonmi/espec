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

  @agent_name :espec_let_agent

  @doc """
  The macro defines funtion with random name which returns block value.
  That function will be called when example is run.
  The function will place the block value to the Agent dict.
  """
  defmacro let(var, do: block) do
    function = random_let_name
    block = Macro.escape(block)

    quote do
      tail = @context
      head =  %ESpec.Let{var: unquote(var), module: __MODULE__, function: unquote(function)}

      def unquote(function)(var!(shared)) do
        var!(shared)
        {unquote(block), var!(shared)}
      end

      @context [head | tail]

      unless ESpec.Let.agent_get({__MODULE__, "already_defined_#{unquote(var)}"}) do
        def unquote(var)() do
          {result, assigns} = ESpec.Let.agent_get({self, __MODULE__, unquote(var)})
          #TODO This __ENV__ hack is annoying
          functions = [{__MODULE__, __MODULE__.__info__(:functions)} | __ENV__.functions]
          env = %{__ENV__ | functions: functions}
          {result, _assigns} = Code.eval_quoted(result, [shared: assigns], env)
          ESpec.Let.agent_put({self, __MODULE__, unquote(var)}, {resultw, assigns})
          result
        end
        ESpec.Let.agent_put({__MODULE__, "already_defined_#{unquote(var)}"}, true)
      end
    end
  end

  @doc "let! evaluate block like `before`"
  defmacro let!(var, do: block) do
    quote do
      let unquote(var), do: unquote(block)
      before do: unquote(block)
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

  @doc "Starts Agent to save state of 'lets'."
  def start_agent, do: Agent.start_link(fn -> Map.new end, name: @agent_name)

  @doc "Stops Agent"
  def stop_agent, do: Agent.stop(@agent_name)

  @doc "Get stored value."
  def agent_get(key) do
    dict = Agent.get(@agent_name, &(&1))
    Dict.get(dict, key)
  end

  @doc "Store value."
  def agent_put(key, value), do: Agent.update(@agent_name, &(Dict.put(&1, key, value)))

  defp random_let_name, do: String.to_atom("let_#{ESpec.Support.random_string}")
end
