defmodule ESpec.Mock do

	@agent_name :espec_mock_agent

	def expect(module, name, function) do
		try do
			:meck.new(module, [:non_strict])
		rescue
			error in [ErlangError] ->
				case error do
					%ErlangError{original: {:already_started, _pid}} -> :ok
					_ -> raise error
				end
		end
		:meck.expect(module, name, function)
		agent_put(module)
	end

	@doc "Unload modules at the end of examples"
	def unload do
		:meck.unload(agent_get)
		agent_del_all
	end

 	@doc "Start Agent to save mocked modules."
  def start_agent do
    Agent.start_link(fn -> HashSet.new end, name: @agent_name)
  end

  @doc false
  def agent_get do
    set = Agent.get(@agent_name, &(&1))
    Set.to_list(set)
  end

  @doc false
  def agent_del_all do
    Agent.update(@agent_name, fn(_state) -> HashSet.new end)
  end

  @doc false
  def agent_put(key) do
    Agent.update(@agent_name, &(Set.put(&1, key)))
  end

end
