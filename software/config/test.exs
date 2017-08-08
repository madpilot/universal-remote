use Mix.Config

config :universal_remote, CEC.Process,
  executable: Path.expand("#{__DIR__}/../spec/fake/cec-client")

config :universal_remote, LIRC.Process,
  irsend: Path.expand("#{__DIR__}/../spec/fake/irsend"),
  irw: Path.expand("#{__DIR__}/../spec/fake/irw")

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :universal_remote, UniversalRemote.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
