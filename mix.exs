defmodule ESpec.Mixfile do
  use Mix.Project

  def project do
    [app: :espec,
     name: "Espec",
     version: "0.1.0",
     elixir: "~> 1.0",
     description: description,
     package: package,
     deps: deps,
     preferred_cli_env: [espec: :test]]
  end

  def application do
    [applications: []]
  end

  defp deps do
    []
  end

  defp description do
    """
      ESpec is RSpec for Elixir
    """
  end

  defp package do
   [
     files: ["lib", "spec", "mix.exs", "README.md"],
     contributors: ["Anton Mishchuk"],
     licenses: ["MIT"],
     links: %{"github" => "https://github.com/antonmi/espec"}
   ]
 end
end
