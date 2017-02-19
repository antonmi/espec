defmodule ESpec.Formatters.WriteOutput do
  def write_output(output, file) do
    if file do
      IO.write(file, output)
    else
      IO.write(output)
    end
  end

  def create_out_file!(path) do
    File.mkdir_p!(Path.dirname(path))
    {:ok, file} = File.open(path, [:write])
    file
  end

  def close_out_file(path) do
    File.close(path)
  end
end
