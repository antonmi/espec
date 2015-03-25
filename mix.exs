defmodule ESpec.Mixfile do
  use Mix.Project

  def project do
    [app: :espec,
     version: "0.1.0",
     elixir: "~> 1.0",
     deps: deps]
  end

  def application do
    [applications: []]
  end

  defp deps do
    []
  end

  defp description do
    "ESpec is RSpec for Elixir"
  end

  defp package do
   [
     files: ["lib", "spec"],
     contributors: ["Anton Mishchuk"],
     licenses: ["MIT"],
     links: %{"github" => "https://github.com/antonmi/espec"}
   ]
 end
end
