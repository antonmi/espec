defmodule Mix.Tasks.Espec do
  use Mix.Task

  @shortdoc "Runs specs"

  def run(args) do
    {opts, files, _} = OptionParser.parse(args)

    unless System.get_env("MIX_ENV") || Mix.env == :test do
      Mix.raise "espec is running on environment #{Mix.env}.\n" <>
                "It is recommended to run espec in test environment.\n" <>
                "Please add `preferred_cli_env: [espec: :test]` to project configurations in mix.exs file.\n" <>
                "Or set MIX_ENV explicitly (MIX_ENV=test mix espec)"
    end

    Mix.Task.run "loadpaths", args

    Mix.shell.print_app
    Mix.Task.run "app.start", args

    # Ensure espec is loaded.
    case Application.load(:espec) do
      :ok -> :ok
      {:error, {:already_loaded, :espec}} -> :ok
    end

    spec_paths = ["spec"]
    spec_pattern = "*_spec.exs"

    ESpec.Configuration.add(opts)
    Enum.each([spec_paths], &require_spec_helper(&1))

    files_with_opts = []

    if Enum.any?(files) do
      files_with_opts = parse_files(files)
      spec_files = files_with_opts |> Enum.map(fn {f,_} -> f end)
      spec_files = Mix.Utils.extract_files(spec_files, spec_pattern)
    else
      spec_files = Mix.Utils.extract_files(spec_paths, spec_pattern)
    end

    Kernel.ParallelRequire.files(spec_files)
    
    ESpec.Configuration.add([file_opts: files_with_opts])
    success = ESpec.run

    System.at_exit fn _ ->
      unless success, do: exit({:shutdown, 1})
    end
  end


  def parse_files(files), do: files |> Enum.map(&parse_file(&1))

  def parse_file(file) do
    case Regex.run(~r/^(.+):(\d+)$/, file, capture: :all_but_first) do
      [file, line_number] ->
        {Path.absname(file), [line: String.to_integer(line_number)]}
      nil ->
        {Path.absname(file), []}
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
