use Mix.Config

config :universal_remote, CEC.Process,
  executable: Path.expand("#{__DIR__}/../spec/fake/cec-client")

config :universal_remote, LIRC.Process,
  irsend: Path.expand("#{__DIR__}/../spec/fake/irsend"),
  irw: Path.expand("#{__DIR__}/../spec/fake/irw")

config :universal_remote,
  devices: %{
    test_device: "spec/fixtures/test_device.exs"
  }

# Print only warnings and errors during test
config :logger, level: :warn
