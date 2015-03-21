defmodule ESpec.Let do

  defmacro let(var, do: block) do
    quote do

      defp unquote(var)() do
        unless Process.whereis(agent_name(__MODULE__)), do: start_agent(__MODULE__)
        cached = get(__MODULE__, unquote(var))
        unless cached do
          cached = unquote(block)
          put(__MODULE__, unquote(var), cached)
          cached
        end
        cached
      end

    end
  end

  def start_agent(module) do
    Agent.start_link(fn -> HashDict.new end, name: agent_name(module))
  end

  def get(module, key) do
    dict = Agent.get(agent_name(module), &(&1))
    Dict.get(dict, key)
  end

  def put(module, key, value) do
    Agent.update(agent_name(module), &(Dict.put(&1, key, value)))
  end

  def agent_name(module) do
    String.to_atom("#{module}_let_agent")
  end

end
