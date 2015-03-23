defmodule ESpec.Let do

  defstruct var: nil, function: nil

  @let_agent_name :espec_let_agent


  defmacro let(var, do: block) do
    function = random_let_name

    quote do
      tail = @context
      head =  %ESpec.Let{var: unquote(var), function: unquote(function)}
      def unquote(function)(), do: unquote(block)

      @context [head | tail]

      unless let_agent_get({__MODULE__, "already_defined_#{unquote(var)}"}) do
        def unquote(var)(), do: let_agent_get({__MODULE__, unquote(var)})
        let_agent_put({__MODULE__, "already_defined_#{unquote(var)}"}, true)
      end

    end
  end

  def random_let_name, do: String.to_atom("let_#{ESpec.Support.random_string}")

  defmacro subject(do: block) do
    quote do
      tail = @context
      head =  %ESpec.Subject{value: unquote(block)}
      @context [head | tail]
    end
  end

  def start_let_agent do
    Agent.start_link(fn -> HashDict.new end, name: @let_agent_name)
  end

  def let_agent_get({module, func}) do
    dict = Agent.get(@let_agent_name, &(&1))
    Dict.get(dict, {module, func})
  end

  def let_agent_put({module, func}, value) do
    Agent.update(@let_agent_name, &(Dict.put(&1, {module, func}, value)))
  end

  def let_agent_del({module, func}) do
    Agent.update(@let_agent_name, &(Dict.delete(&1, {module, func})))
  end

end
