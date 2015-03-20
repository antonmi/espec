defmodule Mix.Tasks.Spec do
  use Mix.Task

  def run(args) do
    {opts, files, _} = OptionParser.parse(args, switches: @switches)

    Mix.Task.run "loadpaths", args

    project = Mix.Project.config

    Mix.shell.print_app
    Mix.Task.run "app.start", args

    # Ensure espec is loaded.
    case Application.load(:espec) do
      :ok -> :ok
      {:error, {:already_loaded, :espec}} -> :ok
    end


    ESpec.Config.configure(opts)

    Enum.each(["spec"], &require_spec_helper(&1))


    spec_files   = parse_files(files)
    spec_pattern = "*_spec.exs"
    #
    spec_files = Mix.Utils.extract_files(spec_files, "*_spec.exs")
    _ = Kernel.ParallelRequire.files(spec_files)

 require IEx; IEx.pry

    ESpec.run

    # # Run the test suite, coverage tools and register an exit hook
    # %{failures: failures} = ExUnit.run
    # if cover, do: cover.()
    #
    # System.at_exit fn _ ->
    #   if failures > 0, do: exit({:shutdown, 1})
    # end
  end

  def parse_files(files) do
    files |> Enum.map(fn(file) ->
      {file, opts} =  parse_file(file)
      ESpec.Config.configure([{file, opts}])
      file
    end)
  end

  def parse_file(file) do
    case Regex.run(~r/^(.+):(\d+)$/, file, capture: :all_but_first) do
      [file, line_number] ->
        {file, [line: line_number]}
      nil ->
        {file, []}
    end
  end


  defp require_spec_helper(dir) do
    file = Path.join(dir, "spec_helper.exs")

    if File.exists?(file) do
      Code.require_file file
    else
      Mix.raise "Cannot run tests because spec helper file #{inspect file} does not exist"
    end
  end


end
