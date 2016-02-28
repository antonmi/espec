defmodule ESpec.Mixfile do
  use Mix.Project

  @version "0.8.15"

  def project do
    [app: :espec,
     name: "ESpec",
     version: @version,
     elixir: ">= 1.1.0",
     description: description,
     package: package,
     deps: deps,
     source_url: "https://github.com/antonmi/espec",
     preferred_cli_env: [espec: :test]
   ]
  end

  def application do
    [applications: []]
  end

  defp deps do
    [
      {:meck, "~> 0.8.4"},
      # Docs
      {:earmark, "~> 0.2.1", only: :docs},
      {:ex_doc, "~> 0.11.4", only: :docs}
    ]
  end

  defp description do
    """
       BDD test framework for Elixir inspired by RSpec.
    """
  end

  defp package do
   [
     files: ~w(lib mix.exs README.md),
     maintainers: ["Anton Mishchuk"],
     licenses: ["MIT"],
     links: %{"github" => "https://github.com/antonmi/espec"}
   ]
 end
end
