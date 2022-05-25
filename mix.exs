defmodule ESpec.Mixfile do
  use Mix.Project

  @version "1.9.0"

  def project do
    [
      app: :espec,
      name: "ESpec",
      version: @version,
      elixir: ">= 1.10.0",
      description: description(),
      package: package(),
      deps: deps(),
      source_url: "https://github.com/antonmi/espec",
      preferred_cli_env: [espec: :test]
    ]
  end

  def application do
    [applications: [], extra_applications: [:eex, :meck]]
  end

  defp deps do
    [
      {:meck, "~> 0.9"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      # Docs
      {:ex_doc, "~> 0.28", only: [:docs, :dev]}
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
