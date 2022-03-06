# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures Elixir's Logger
config :logger,
  backends: [:console]

config :logger, :console,
  colors: [enabled: true],
  format: "[$level] $message\n",
  level: :info,
  utc_log: true

config :universal_remote,
  :servers,
    web: [
      enabled: true,
      scheme: :http,
      options: [
        ip: {0, 0, 0, 0},
        port: 4001
      ]
    ]

config :universal_remote,
  :buses,
    modules: [
      Event.Supervisor,
      CEC.Supervisor,
      LIRC.Supervisor
    ]

config :universal_remote,
  devices: %{
    receiver: "priv/devices/receiver.exs",
    lounge_room: "priv/devices/lounge_room.exs"
  }

config :universal_remote,
  remotes: %{
    cec: CEC.Remote,
    lirc: LIRC.Remote
  }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
