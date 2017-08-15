use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :universal_remote, CEC.Process,
  executable: Path.expand("#{__DIR__}/../spec/fake/cec-client")

config :universal_remote, LIRC.Process,
  irsend: Path.expand("#{__DIR__}/../spec/fake/irsend"),
  irw: Path.expand("#{__DIR__}/../spec/fake/irw")

# Do not include metadata nor timestamps in development logs
config :logger, :console, level: :debug
