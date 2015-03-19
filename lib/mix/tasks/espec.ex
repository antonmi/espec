defmodule Mix.Tasks.Spec do
  use Mix.Task

  def run(args) do
    {opts, files, _} = OptionParser.parse(args, switches: @switches)

    # unless System.get_env("MIX_ENV") || Mix.env == :test do
    #   Mix.raise "mix espec is running on environment #{Mix.env}. If you are " <>
    #   "running tests along another task, please set MIX_ENV explicitly"
    # end

    Mix.Task.run "loadpaths", args

    if Keyword.get(opts, :compile, true) do
      Mix.Task.run "compile", args
    end

    project = Mix.Project.config


    # Start the app and configure espec with command line options
    # before requiring spec_helper.exs so that the configuration is
    # available in spec_helper.exs. Then configure espec again so
    # that command line options override spec_helper.exs
    Mix.shell.print_app
    Mix.Task.run "app.start", args

    # Ensure ex_unit is loaded.
    case Application.load(:espec) do
      :ok -> :ok
      {:error, {:already_loaded, :espec}} -> :ok
    end



    # opts = ex_unit_opts(opts)
    # ExUnit.configure(opts)
    #
    spec_paths = project[:spec_paths] || ["spec"]
    Enum.each(spec_paths, &require_spec_helper(&1))
    # ExUnit.configure(opts)
    #
    # Finally parse, require and load the files
    spec_files   = parse_files(files, spec_paths)
    spec_pattern = project[:spec_pattern] || "*_spec.exs"
    #
    spec_files = Mix.Utils.extract_files(spec_files, spec_pattern)
    _ = Kernel.ParallelRequire.files(spec_files)

    ESpec.run

    # # Run the test suite, coverage tools and register an exit hook
    # %{failures: failures} = ExUnit.run
    # if cover, do: cover.()
    #
    # System.at_exit fn _ ->
    #   if failures > 0, do: exit({:shutdown, 1})
    # end
  end

  defp parse_files([], test_paths) do
    test_paths
  end

  defp parse_files([single_file], _test_paths) do
    # Check if the single file path matches test/path/to_test.exs:123, if it does
    # apply `--only line:123` and trim the trailing :123 part.
    {single_file, opts} = ExUnit.Filters.parse_path(single_file)
    ExUnit.configure(opts)
    [single_file]
  end

  defp parse_files(files, _test_paths) do
    files
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
