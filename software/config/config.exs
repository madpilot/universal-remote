# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :universal_remote, UniversalRemote.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "tPE5J6AHCCSOTd9tVByf+5XjRGdBcgkNTJpXUB9I1/X9IDnTixMR7nHjnL8fWbaA",
  render_errors: [view: UniversalRemote.ErrorView, accepts: ~w(html json)],
  pubsub: [name: UniversalRemote.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
