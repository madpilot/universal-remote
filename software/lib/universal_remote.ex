defmodule UniversalRemote do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      supervisor(UniversalRemote.Apis.Rest.Endpoint, []),
      # Start your own worker by calling: UniversalRemote.Worker.start_link(arg1, arg2, arg3)
      # worker(UniversalRemote.Worker, [arg1, arg2, arg3]),
      supervisor(CEC.Supervisor, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UniversalRemote.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    UniversalRemote.Apis.Rest.Endpoint.config_change(changed, removed)
    :ok
  end
end
