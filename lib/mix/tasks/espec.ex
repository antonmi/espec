defmodule Mix.Tasks.Espec do
  alias Mix.Utils.Stale

  defmodule Cover do
    @moduledoc false

    def start(compile_path, opts) do
      Mix.shell().info("Cover compiling modules ... ")
      _ = :cover.start()

      case :cover.compile_beam_directory(compile_path |> to_charlist) do
        results when is_list(results) ->
          :ok

        {:error, _} ->
          Mix.raise("Failed to cover compile directory: " <> compile_path)
      end

      output = opts[:output]

      fn ->
        Mix.shell().info("\nGenerating cover results ... ")
        File.mkdir_p!(output)
        Enum.each(:cover.modules(), fn mod -> cover_function(mod, output) end)
      end
    end

    defp cover_function(mod, output) do
      case :cover.analyse_to_file(mod, ~c"#{output}/#{mod}.html", [:html]) do
        {:ok, _} -> nil
        {:error, error} -> Mix.shell().info("#{error} while generating cover results for #{mod}")
      end
    end
  end

  use Mix.Task

  @shortdoc "Runs specs"
  @preferred_cli_env :test
  alias ESpec.Configuration

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
    * `--sync`       - run all specs synchronously ignoring 'async' tag
    * `--trace`      - detailed output
    * `--cover`      - enable code coverage
    * `--only`       - run only tests that match the filter `--only some:tag`
    * `--exclude`    - exclude tests that match the filter `--exclude some:tag`
    * `--string`     - run only examples whose full nested descriptions contain string `--string 'only this'`
    * `--seed`       - seeds the random number generator used to randomize tests order
    * `--stale`      - The --stale command line option attempts to run only those test files which reference modules that have changed since the last time you ran this task with --stale

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
  @recursive true

  @switches [
    focus: :boolean,
    silent: :boolean,
    order: :boolean,
    sync: :boolean,
    trace: :boolean,
    cover: :boolean,
    only: :string,
    exclude: :string,
    string: :string,
    seed: :integer,
    stale: :boolean
  ]

  def run(args) do
    {opts, files, mix_opts} = OptionParser.parse(args, strict: @switches)

    check_env!()
    Mix.Task.run("loadpaths", args)

    if Keyword.get(mix_opts, :compile, true), do: Mix.Task.run("compile", args)

    project = Mix.Project.config()
    cover = Keyword.merge(@cover, project[:test_coverage] || [])

    # Start cover after we load deps but before we start the app.
    cover =
      if opts[:cover] do
        cover[:tool].start(Mix.Project.compile_path(project), cover)
      end

    Mix.shell().print_app()
    Mix.Task.run("app.start", args)

    ensure_espec_loaded!()

    set_configuration(opts)

    success = run_espec(project, files, cover)

    System.at_exit(fn _ -> unless success, do: exit({:shutdown, 1}) end)
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

  defp run_espec(project, files, cover) do
    ESpec.start()

    if parse_spec_files(project, files) do
      success = ESpec.run()
      if cover, do: cover.()
      ESpec.stop()
      success
    else
      false
    end
  end

  defp require_spec_helper(dir) do
    file = Path.join(dir, "spec_helper.exs")

    if File.exists?(file) do
      Code.require_file(file)
      true
    else
      IO.puts("Cannot run tests because spec helper file `#{file}` does not exist.")
      false
    end
  end

  defp check_env! do
    if elixir_version() < "1.3.0" do
      unless System.get_env("MIX_ENV") || Mix.env() == :test do
        Mix.raise(
          "espec is running on environment #{Mix.env()}.\n" <>
            "It is recommended to run espec in test environment.\n" <>
            "Please add `preferred_cli_env: [espec: :test]` to project configurations in mix.exs file.\n" <>
            "Or set MIX_ENV explicitly (MIX_ENV=test mix espec)"
        )
      end
    end
  end

  defp elixir_version do
    System.version() |> String.split("-") |> hd
  end

  defp ensure_espec_loaded! do
    case Application.load(:espec) do
      :ok -> :ok
      {:error, {:already_loaded, :espec}} -> :ok
    end
  end

  defp set_configuration(opts) do
    Configuration.add(start_loading_time: :os.timestamp())
    Configuration.add(opts)
  end

  defp parse_spec_files(project, files) do
    spec_paths = get_spec_paths(project)
    spec_pattern = get_spec_pattern(project)

    if Enum.all?(spec_paths, &require_spec_helper(&1)) do
      files_with_opts = if Enum.any?(files), do: parse_files(files), else: []
      shared_spec_files = extract_shared_specs(project)

      compile_result =
        files_with_opts
        |> Enum.map(&elem(&1, 0))
        |> if_empty_use(spec_paths)
        |> extract_files(spec_pattern)
        |> filter_stale_files()
        |> compile(include_shared: shared_spec_files)

      case compile_result do
        {:error, _, _} ->
          false

        _ ->
          Configuration.add(file_opts: files_with_opts)
          Configuration.add(shared_specs: shared_spec_files)
          Configuration.add(finish_loading_time: :os.timestamp())
      end
    else
      false
    end
  end

  defp filter_stale_files(test_files) do
    case Configuration.get(:stale) do
      true ->
        test_files
        |> Stale.set_up_stale_sources()

      _ ->
        {test_files, []}
    end
  end

  defp if_empty_use([], default), do: default
  defp if_empty_use(value, _default), do: value

  defp get_spec_paths(project) do
    project[:spec_paths] || ["spec"]
  end

  defp get_spec_pattern(project) do
    project[:spec_pattern] || "*_spec.exs"
  end

  defp extract_files(paths, pattern) do
    already_loaded = MapSet.new(Code.required_files())

    paths
    |> Mix.Utils.extract_files(pattern)
    |> Enum.map(&Path.absname/1)
    |> Enum.reject(fn path ->
      full_path = Path.expand(path)

      MapSet.member?(already_loaded, full_path)
    end)
  end

  defp extract_shared_specs(project) do
    shared_spec_paths = get_shared_spec_paths(project)
    shared_spec_pattern = get_shared_spec_pattern(project)

    extract_files(shared_spec_paths, shared_spec_pattern)
  end

  defp get_shared_spec_paths(project) do
    project[:shared_spec_paths] || default_shared_spec_paths(project)
  end

  defp default_shared_spec_paths(project) do
    project
    |> get_spec_paths()
    |> Enum.map(&Path.join(&1, "shared"))
  end

  defp get_shared_spec_pattern(project) do
    project[:shared_spec_pattern] || get_spec_pattern(project)
  end

  defp compile({spec_files, parallel_require_callbacks}, include_shared: shared_spec_files) do
    shared_spec_files = shared_spec_files || []

    shared_spec_files
    |> Enum.each(&Code.require_file/1)

    Kernel.ParallelCompiler.compile(spec_files -- shared_spec_files, parallel_require_callbacks)
  end
end
