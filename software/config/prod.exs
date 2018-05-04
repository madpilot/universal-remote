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
      scheme: :https,
      options: [
        ip: {0, 0, 0, 0},
        port: 443,
        keyfile: "priv/ssl/key.pem",
        certfile: "priv/ssl/cert.pem"
      ]
    ]
