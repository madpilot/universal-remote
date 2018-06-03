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
     preferred_cli_env: [espec: :test, "coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
     test_coverage: [tool: ExCoveralls, test_task: "espec"],
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {UniversalRemote, []},
     applications: [:ranch, :cowboy, :logger, :plug, :file_system],
     preferred_cli_env: [espec: :test]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:gen_stage, "~> 0.13.1"},
      {:cowboy, "~> 1.1.2"},
      {:apex, "~>1.2.0", only: [:dev,:test]},
      {:espec, "~> 1.5.1", only: :test},
      {:excoveralls, "~> 0.8", only: :test},
      {:logger_file_backend, "~> 0.0.10"},
      {:plug, "~> 1.5.0"},
      {:poison, "~> 3.1"},
      {:fs, "~> 2.12.0"},
      {:file_system, "~> 0.2"}
    ]
  end
end
