defmodule Supervisors.Servers do
  use Supervisor
  require Logger

  defp cowboy_config(config) do
    config
    |> List.insert_at(0, {:otp_app, :universal_remote})
  end

  def start_link() do
    {:ok, config} = Application.fetch_env(:universal_remote, :servers)
    Supervisor.start_link(__MODULE__, config, [name: __MODULE__])
  end

  def init(config) do
    children = [
      Plug.Adapters.Cowboy.child_spec(config[:web][:scheme], Server.Web.Router, [], cowboy_config(config[:web][:options]))
    ]
    Logger.info "Servers - Initializing web server on port #{config[:web][:port]}"
    supervise(children, strategy: :one_for_one)
  end
end
