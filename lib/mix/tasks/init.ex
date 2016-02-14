defmodule Mix.Tasks.Espec.Init do
  use Mix.Task
  import Mix.Generator

  @preferred_cli_env :test

  @shortdoc "Create spec/spec_helper.exs and spec/example_spec.exs"

  @moduledoc """
  Creates neccessary files.

  This tasks creates `spec/spec_helper.exs` and `spec/example_spec.exs`

  ## Command line options

  * `--skip-examples` - skip creating of example files

  """

  @spec_folder "spec"
  @spec_helper "spec_helper.exs"
  @example_spec "example_spec.exs"

  def run(args) do
    {opts, _, _} = OptionParser.parse(args)

    create_directory @spec_folder
    create_file(Path.join(@spec_folder, @spec_helper), spec_helper_template(nil))

    unless opts[:skip_examples] do
      create_file(Path.join(@spec_folder, @example_spec), example_spec_template(nil))
    end
  end

  embed_template :spec_helper, """
  ESpec.start

  ESpec.configure fn(config) ->
    config.before fn ->
      {:shared, hello: :world}
    end

    config.finally fn(_shared) ->
      :ok
    end
  end
  """

  embed_template :example_spec, """
  defmodule ExampleSpec do
    use ESpec

    before do
      answer = Enum.reduce((1..9), &(&2 + &1)) - 3
      {:shared, answer: answer} #saves {:key, :value} to `shared`
    end

    example "test" do
      expect shared.answer |> to(eq 42)
    end

    context "Defines context" do
      subject(shared.answer)

      it do: is_expected.to be_between(41, 43)

      describe "is an alias for context" do
        before do
          value = shared.answer * 2
          {:shared, new_answer: value}
        end

        let :val, do: shared.new_answer

        it "checks val" do
          expect val |> to(eq 84)
        end
      end
    end

    xcontext "xcontext skips examples." do
      xit "And xit also skips" do
        "skipped"
      end
    end

    pending "There are so many features to test!"
  end
  """
end
