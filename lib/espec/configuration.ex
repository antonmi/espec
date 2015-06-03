defmodule ESpec.Configuration do
  
  @list [
    hello: "Description",
    before: "Defines before hook",
    finally: "Defines finally hook",
    silent: "No output",
    file_opts: "Run the specific file or spec in the file",
    format: "Specifies format: 'doc', 'html', 'json'",
    trace: "Alias for 'format=doc'",
    focus: "Run only examples with [focus: true]",
    order: "Run specs in the order in which they are declared",
    test: "For test purpose",
    start_loading_time: "Starts loading files",
    finish_loading_time: "Finished loading",
    finish_specs_time: "Finished specs"
  ]

  def add(opts) do
    opts |> Enum.each fn {key, val} ->
      if Enum.member?(Keyword.keys(@list), key) do
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

  Keyword.keys(@list) |> Enum.each fn(func) ->
    def unquote(func)(value, {ESpec.Configuration}) do
      ESpec.Configuration.add([{unquote(func), value}])
    end
  end

end


