defmodule UniversalRemote.Mixfile do
  use Mix.Project

  def project do
    [app: :universal_remote,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     preferred_cli_env: [espec: :test],
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {UniversalRemote, []},
     applications: [:ranch, :cowboy, :logger, :plug]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:gen_stage, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:apex, "~>1.0.0", only: [:dev,:test]},
      {:espec, "~> 1.4.5", only: :test},
      {:plug, "~> 1.4.3"},
      {:poison, "~> 3.1"}]
  end
end
