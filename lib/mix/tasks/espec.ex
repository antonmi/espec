defmodule Mix.Tasks.Espec do
  defmodule Cover do
    @moduledoc false

    def start(compile_path, opts) do
      Mix.shell.info "Cover compiling modules ... "
      _ = :cover.start

      case :cover.compile_beam_directory(compile_path |> to_char_list) do
        results when is_list(results) ->
          :ok
        {:error, _} ->
          Mix.raise "Failed to cover compile directory: " <> compile_path
      end

      output = opts[:output]

      fn() ->
        Mix.shell.info "\nGenerating cover results ... "
        File.mkdir_p!(output)
        Enum.each :cover.modules, fn(mod) ->
          case :cover.analyse_to_file(mod, '#{output}/#{mod}.html', [:html]) do
            {:ok, _} -> nil
            {:error, error} -> Mix.shell.info "#{error} while generating cover results for #{mod}"
          end
        end
      end
    end
  end

  use Mix.Task

  @shortdoc "Runs specs"

  @moduledoc """
  Runs the specs.

  This task starts the current application, loads up
  `spec/spec_helper.exs` and then requires all files matching the
  `spec/**/_spec.exs` pattern in parallel.

  A list of files can be given after the task name in order to select
  the files to compile:

      mix espec spec/some/particular/file_spec.exs

  In case a single file is being tested, it is possible pass a specific
  line number:

      mix espec spec/some/particular/file_spec.exs:42    

  ## Command line options

    * `--focus`      - run examples with `focus` only
    * `--silent`     - no output
    * `--order`      - run examples in the order in which they are declared
    * `--format`     - choose formatter ('doc', 'html', 'json')
    * `--cover`      - enable code coverage

  ## Configuration
    * `:spec_paths` - list of paths containing spec files, defaults to `["spec"]`.
      It is expected all spec paths to contain a `spec_helper.exs` file.

    * `:spec_pattern` - a pattern to load spec files, defaults to `*_spec.exs`.

    * `:test_coverage` - a set of options to be passed down to the coverage mechanism.

  ## Coverage

  The `:test_coverage` configuration accepts the following options:

    * `:output` - the output for cover results, defaults to `"cover"`
    * `:tool`   - the coverage tool

  By default, a very simple wrapper around OTP's `cover` is used as a tool,
  but it can be overridden as follows:

      test_coverage: [tool: CoverModule]

  `CoverModule` can be any module that exports `start/2`, receiving the
  compilation path and the `test_coverage` options as arguments. It must
  return an anonymous function of zero arity that will be run after the
  test suite is done or `nil`.
  """

  @cover [output: "cover", tool: Cover]

  def run(args) do
    {opts, files, _} = OptionParser.parse(args)

    unless System.get_env("MIX_ENV") || Mix.env == :test do
      Mix.raise "espec is running on environment #{Mix.env}.\n" <>
                "It is recommended to run espec in test environment.\n" <>
                "Please add `preferred_cli_env: [espec: :test]` to project configurations in mix.exs file.\n" <>
                "Or set MIX_ENV explicitly (MIX_ENV=test mix espec)"
    end

    Mix.Task.run "loadpaths", args

    project = Mix.Project.config
    cover   = Keyword.merge(@cover, project[:test_coverage] || [])

    # Start cover after we load deps but before we start the app.
    cover =
      if opts[:cover] do
        cover[:tool].start(Mix.Project.compile_path(project), cover)
      end

    Mix.shell.print_app
    Mix.Task.run "app.start", args

    # Ensure espec is loaded.
    case Application.load(:espec) do
      :ok -> :ok
      {:error, {:already_loaded, :espec}} -> :ok
    end

    spec_paths = project[:spec_paths] || ["spec"] 
    spec_pattern =  project[:spec_pattern] || "*_spec.exs"

    ESpec.Configuration.add(opts)
    Enum.each(spec_paths, &require_spec_helper(&1))

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

    if cover, do: cover.()

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
