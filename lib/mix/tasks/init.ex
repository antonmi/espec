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

  def run(_args) do
    create_directory(@spec_folder)
    create_file(Path.join(@spec_folder, @spec_helper), spec_helper_template(nil))
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
end
