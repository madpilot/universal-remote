defmodule Supervisors.Servers do
  use Supervisor

  def start_link() do
    {:ok, config} = Application.fetch_env(:universal_remote, :servers)
    Supervisor.start_link(__MODULE__, config, [name: __MODULE__])
  end

  def init(config) do
    children = [
      Plug.Adapters.Cowboy.child_spec(:https, Server.Web.Router, [], config[:web])
    ]
    supervise(children, strategy: :one_for_one)
  end
end
