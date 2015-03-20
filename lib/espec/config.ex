defmodule ESpec.Config do


  def configure(opts) do
    opts |> Enum.each fn {k, v} ->
      Application.put_env(:espec, k, v)
    end
  end

  def configuration do
    Application.get_all_env(:espec)
  end
  

end
