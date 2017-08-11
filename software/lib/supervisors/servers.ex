defmodule Supervisors.Servers do
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, %{}, [name: __MODULE__])
  end

  def init(_) do
    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Server.Web.Router, [], [port: 4001])
    ]
    supervise(children, strategy: :one_for_one)
  end
end
