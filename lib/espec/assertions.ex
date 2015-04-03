defmodule ESpec.Assertions do
  @moduledoc """
  Keep the dictionary with all available assertions.
  One can add custom assertion.
  """

  @agent_name :espec_assertions_agent
  
  @assertions [
    {:eq, ESpec.Assertions.Eq},
    {:eql, ESpec.Assertions.Eql},
    {:be, ESpec.Assertions.Be},
    {:be_between, ESpec.Assertions.BeBetween},
    {:be_close, ESpec.Assertions.BeCloseTo},
    {:match, ESpec.Assertions.Match},
      
    {:raise_exception, ESpec.Assertions.RaiseException},
    {:throw_term, ESpec.Assertions.ThrowTerm},

    {:change_to, ESpec.Assertions.ChangeTo},
    {:change_from_to, ESpec.Assertions.ChangeFromTo},
      
    {:have_all, ESpec.Assertions.Enum.HaveAll},
    {:have_any, ESpec.Assertions.Enum.HaveAny},
    {:have_at, ESpec.Assertions.Enum.HaveAt},
    {:have_count, ESpec.Assertions.Enum.HaveCount},
    {:have_count_by, ESpec.Assertions.Enum.HaveCountBy},
    {:have, ESpec.Assertions.Enum.Have},
    {:be_empty, ESpec.Assertions.Enum.BeEmpty},
    {:have_max, ESpec.Assertions.Enum.HaveMax},
    {:have_max_by, ESpec.Assertions.Enum.HaveMaxBy},
    {:have_min, ESpec.Assertions.Enum.HaveMin},
    {:have_min_by, ESpec.Assertions.Enum.HaveMinBy},
      
    {:have_first, ESpec.Assertions.List.HaveFirst},
    {:have_last, ESpec.Assertions.List.HaveLast},
    {:have_hd, ESpec.Assertions.List.HaveHd},
    {:have_tl, ESpec.Assertions.List.HaveTl},
      
    {:be_type, ESpec.Assertions.BeType},

    {:accepted, ESpec.Assertions.Accepted}
  ]

  @doc "Start the agent and fill the dictionary with `@assertions`"
  def init do
    start_agent
    register @assertions
  end   

  @doc "Register assertion"
  def register(list) when is_list(list) do
    Enum.each list, &(register(&1))
  end

  def register({key, module}) do
    agent_put(key, module)
  end

  defp start_agent do
    Agent.start_link(fn -> HashDict.new end, name: @agent_name)
  end

  @doc "Get stored value. Used by `ESpec.ExpectTo.to`"
  def agent_get(key) do
    dict = Agent.get(@agent_name, &(&1))
    Dict.get(dict, key)
  end

  defp agent_put(key, value) do
    Agent.update(@agent_name, &(Dict.put(&1, key, value)))
  end

 	
end
