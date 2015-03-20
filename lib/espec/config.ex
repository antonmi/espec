defmodule ESpec.Configuration do


  def add(opts) do
    opts |> Enum.each fn {key, val} ->
      Application.put_env(:espec, key, val)
    end
  end

  def get(key) do
    Application.get_env(:espec, key)
  end

  def all do
    Application.get_all_env(:espec)
  end


end
