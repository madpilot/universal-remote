use Mix.Config

config :universal_remote, CEC.Process,
  executable: Path.expand("/usr/bin/cec-client")

config :universal_remote, LIRC.Process,
  irsend: Path.expand("/usr/bin/irsend"),
  irw: Path.expand("/usr/bin/irw")

config :universal_remote,
  :servers,
    web: [
      enabled: true,
      scheme: :http,
      options: [
        ip: {0, 0, 0, 0},
        port: 80,
      ]
    ]

config :logger,
  backends: [{LoggerFileBackend, :error_log}]

# configuration for the {LoggerFileBackend, :error_log} backend
config :logger, :error_log,
  path: "/var/log/universal-remote/error.log",
  level: :error
