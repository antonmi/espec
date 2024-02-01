defmodule ESpec.Mixfile do
  use Mix.Project

  @version "1.9.2"

  def project do
    [
      app: :espec,
      name: "ESpec",
      version: @version,
      elixir: ">= 1.13.0",
      description: description(),
      package: package(),
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      source_url: "https://github.com/antonmi/espec",
      preferred_cli_env: [espec: :test]
    ]
  end

  def application do
    [extra_applications: [:eex, :meck]]
  end

  defp deps do
    [
      {:meck, "~> 0.9"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      # Docs
      {:ex_doc, "~> 0.31", only: [:docs, :dev]}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/test_modules"]
  defp elixirc_paths(_), do: ["lib"]

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
