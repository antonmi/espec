defmodule ESpec.Mixfile do
  use Mix.Project

  @version "1.6.2"

  def project do
    [
      app: :espec,
      name: "ESpec",
      version: @version,
      elixir: ">= 1.5.0",
      description: description(),
      package: package(),
      deps: deps(),
      source_url: "https://github.com/antonmi/espec",
      preferred_cli_env: [espec: :test]
    ]
  end

  def application do
    [applications: []]
  end

  defp deps do
    [
      {:meck, "0.8.12"},
      {:credo, "0.10.0", only: [:dev, :test], runtime: false},
      # Docs
      {:ex_doc, "0.18.4", only: [:docs, :dev]}
    ]
  end

  defp description do
    "BDD testing framework for Elixir inspired by RSpec."
  end

  defp package do
    [
      files: ~w(lib mix.exs README.md .formatter.exs LICENSE),
      maintainers: ["Anton Mishchuk"],
      licenses: ["MIT"],
      links: %{"github" => "https://github.com/antonmi/espec"}
    ]
  end
end
