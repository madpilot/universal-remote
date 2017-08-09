use Mix.Config

config :universal_remote, CEC.Process,
  executable: Path.expand("/usr/bin/cec-client")

config :universal_remote, LIRC.Process,
  irsend: Path.expand("/usr/bin/irsend"),
  irw: Path.expand("/usr/bin/irw")
