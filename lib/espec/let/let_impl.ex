defmodule ESpec.Let.Impl do
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
