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
     source_url: "https://github.com/antonmi/espec",
     preferred_cli_env: [espec: :test]  
   ]
  end

  def application do
    [applications: []]
  end

  defp deps do
    [
      {:earmark, "~> 0.1", only: :docs},
      {:ex_doc, "~> 0.7.0", only: :docs},
      {:inch_ex, "~> 0.2", only: :docs}
    ]
  end

  defp description do
    """
      ESpec is RSpec for Elixir
    """
  end

  defp package do
   [
     files: ~w(lib mix.exs README.md),
     contributors: ["Anton Mishchuk"],
     licenses: ["MIT"],
     links: %{"github" => "https://github.com/antonmi/espec"}
   ]
 end
end
