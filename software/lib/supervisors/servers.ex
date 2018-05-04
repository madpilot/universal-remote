defmodule Supervisors.Servers do
  use Supervisor
  require Logger

  defp web(children, config) do
    case config[:enabled] do
      true -> (
        scheme = config[:scheme]
        ip = config[:options][:ip]
             |> Tuple.to_list
             |> Enum.join(".")
        port = config[:options][:port]

        options = config[:options]
                  |> List.insert_at(0, {:otp_app, :universal_remote})

        Logger.info "Servers - Initializing web server #{scheme}://#{ip}:#{port}/"
        [Plug.Adapters.Cowboy.child_spec(scheme, Server.Web.Router, [], options) | children ]
      )
      false -> children
    end
  end

  def start_link() do
    {:ok, config} = Application.fetch_env(:universal_remote, :servers)
    Supervisor.start_link(__MODULE__, config, [name: __MODULE__])
  end

  def init(config) do
    children = []
    |> web(config[:web])

    supervise(children, strategy: :one_for_one)
  end
end
