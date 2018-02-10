defmodule ESpec.Let.Impl do
  @moduledoc """
  'let' implementation is here.
  """
  @agent_name :espec_let_agent

  @doc "This function is used by the let macro to implement lazy evaluation"
  def let_eval(module, var) do
    case agent_get({self(), module, var}) do
      {:todo, module, funcname} ->
        shared = agent_get({self(), :shared})
        result = apply(module, funcname, [shared])
        agent_put({self(), module, var}, {:done, result})
        result
      {:done, result} ->
        result
      nil ->
        funcname = case var do
          :subject -> "subject"
          _ -> "let function `#{var}/0`"
        end
        raise ESpec.LetError, "The #{funcname} is not defined in the current scope!"
    end
  end

  @doc "Starts Agent to save state of 'lets'."
  def start_agent, do: Agent.start_link(fn -> Map.new end, name: @agent_name)

  @doc "Stops Agent"
  def stop_agent, do: Agent.stop(@agent_name)

  @doc "Resets stored let value and prepares for evaluation. Called by ExampleRunner."
  def run_before(let) do
    agent_module = if let.shared, do: let.shared_module, else: let.module
    agent_put({self(), agent_module, let.var}, {:todo, let.module, let.function})
  end

  @doc "Clears all let values for the given module. Called by ExampleRunner."
  def clear_lets(module) do
    me = self()
    Agent.update(@agent_name, fn(map) ->
      keys_to_remove = Map.keys(map) |> Enum.filter(&match?({^me, ^module, _}, &1))
      Map.drop(map, keys_to_remove)
    end)
  end

  @doc "Updates the shared map that is available to let blocks. Called by ExampleRunner."
  def update_shared(shared) do
    agent_put({self(), :shared}, shared)
  end

  defp agent_get(key) do
    Agent.get(@agent_name, fn(state) -> Map.get(state, key) end)
  end

  defp agent_put(key, value), do: Agent.update(@agent_name, &(Map.put(&1, key, value)))

  def random_let_name, do: String.to_atom("let_#{ESpec.Support.random_string}")
end
