defmodule ESpec.Let do

  @let_agent_name :espec_let_agent

  defmacro let(var, do: block) do
    quote do

      def unquote(var)() do
        cached = let_agent_get({__MODULE__, unquote(var)})
        unless cached do
          cached = unquote(block)
          let_agent_put({__MODULE__, unquote(var)}, cached)
        end
        cached
      end

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
