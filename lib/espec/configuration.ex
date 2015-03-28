defmodule ESpec.Configuration do
  
  @whitelist ~w(hello before finally silent)a

  def add(opts) do
    opts |> Enum.each fn {key, val} ->
      if Enum.member?(@whitelist, key) do
        Application.put_env(:espec, key, val)
      end
    end
  end

  def get(key) do
    Application.get_env(:espec, key)
  end

  def all do
    Application.get_all_env(:espec)
  end

  def configure(func) do
    func.({ESpec.Configuration})
  end

  @whitelist |> Enum.each fn(func) ->
    def unquote(func)(value, {ESpec.Configuration}) do
      ESpec.Configuration.add([{unquote(func), value}])
    end
  end

end


