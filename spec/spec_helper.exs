ESpec.start

ESpec.configure fn(config) ->
  config.before fn -> {:ok, answer: 42} end
  config.finally fn(shared) -> shared end
end

path = Path.expand("../tmp/beams", __DIR__)
File.rm_rf!(path)
File.mkdir_p!(path)
Code.prepend_path(path)

defmodule ESpec.TestHelpers do
  def write_beam({:module, name, bin, _} = res) do
    beam_path = Path.join(unquote(path), Atom.to_string(name) <> ".beam")
    File.write!(beam_path, bin)
    res
  end
end
