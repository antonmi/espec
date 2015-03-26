defmodule ESpec.Let do
  @moduledoc """
    Defines 'let' and 'subject' macrsos.
    The 'let' macro defines named functions with cached return values.
    The 'subject' macro is just an alias for let to define `subject`.
  """

  @doc """
    Struct keeps the name of variable and random function name.
  """
  defstruct var: nil, function: nil

  @doc """
    The name of Agent to save state for lets and subject
  """
  @let_agent_name :espec_let_agent

  @doc """
    The macro defines funtion with random name which returns block value.
    That function will be called when example is run.
    The function will place the block value to the Agent dict.
  """
  defmacro let(var, do: block) do
    function = random_let_name
    bb = Macro.escape(block)
    quote do
      tail = @context
      head =  %ESpec.Let{var: unquote(var), function: unquote(function)}

      def unquote(function)(), do: unquote(bb)

      @context [head | tail]

      unless let_agent_get({__MODULE__, "already_defined_#{unquote(var)}"}) do
        def unquote(var)() do 
          tree = let_agent_get({__MODULE__, unquote(var)})
          {res, _} = Code.eval_quoted(tree)
          res
        end  
        let_agent_put({__MODULE__, "already_defined_#{unquote(var)}"}, true)
      end
    end
  end

  @doc """
    Defines 'subject'.
  """
  defmacro subject(var) do
    quote do
      unquote(__MODULE__).let(:subject, do: unquote(var))
    end
  end

  @doc """
    Defines 'subject' with name.
    It is just an alias for 'let'.
  """
  defmacro subject(var, do: block) do
    quote do
      unquote(__MODULE__).let(unquote(var), do: unquote(block))
    end
  end

  @doc """
    Start Agent to save state of 'lets'.
  """
  def start_let_agent do
    Agent.start_link(fn -> HashDict.new end, name: @let_agent_name)
  end

  @doc """
    Get stored value.
  """
  def let_agent_get({module, func}) do
    dict = Agent.get(@let_agent_name, &(&1))
    Dict.get(dict, {module, func})
  end

  @doc """
    Store value.
  """
  def let_agent_put({module, func}, value) do
    Agent.update(@let_agent_name, &(Dict.put(&1, {module, func}, value)))
  end

  defp random_let_name, do: String.to_atom("let_#{ESpec.Support.random_string}")
end
