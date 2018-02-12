defmodule Mix.Tasks.Espec.Init do
  use Mix.Task
  import Mix.Generator

  @preferred_cli_env :test

  @shortdoc "Create spec/spec_helper.exs"

  @moduledoc """
  Creates necessary files.

  This tasks creates `spec/spec_helper.exs`
  """

  @spec_folder "spec"
  @spec_helper "spec_helper.exs"
  @shared_spec_folder "shared"
  @shared_spec_example "example_spec.exs"

  def run(_args) do
    create_directory(@spec_folder)
    create_file(Path.join(@spec_folder, @spec_helper), spec_helper_template(nil))

    shared_specs = Path.join(@spec_folder, @shared_spec_folder)

    create_directory(shared_specs)
    create_file(Path.join(shared_specs, @shared_spec_example), shared_spec_example_template(nil))
  end

  embed_template(:spec_helper, """
  ESpec.configure fn(config) ->
    config.before fn(tags) ->
      {:shared, hello: :world, tags: tags}
    end

    config.finally fn(_shared) ->
      :ok
    end
  end
  """)

  embed_template(:shared_spec_example, """
  defmodule ExampleSharedSpec do
    use ESpec, shared: true

    # This shared spec will always be included!
  end
  """)
end
