defmodule Supervisors.Buses do
  use Supervisor

  def start_link() do
    {:ok, config} = Application.fetch_env(:universal_remote, :buses)
    Supervisor.start_link(__MODULE__, config, [name: __MODULE__])
  end

  def init(config) do
    children = config[:modules]
      |> Enum.map(fn(module) -> supervisor(module, []) end)

    supervise(children, strategy: :one_for_one)
  end
end
