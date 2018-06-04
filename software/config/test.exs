use Mix.Config

config :universal_remote, CEC.Process,
  executable: Path.expand("#{__DIR__}/../spec/fake/cec-client")

config :universal_remote, LIRC.Process,
  irsend: Path.expand("#{__DIR__}/../spec/fake/irsend"),
  irw: Path.expand("#{__DIR__}/../spec/fake/irw")

config :universal_remote,
  devices: %{
    test_device: "spec/autoload_fixtures/test_device.exs",
    test_device_2: "spec/autoload_fixtures/test_device_2.exs"
  }


config :universal_remote,
  devices_paths: ["spec/autoload_fixtures"]

config :universal_remote, autoload_devices: false

# Print only warnings and errors during test
config :logger, level: :warn
