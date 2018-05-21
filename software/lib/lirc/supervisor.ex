defmodule LIRC.Supervisor do
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, %{}, [name: __MODULE__])
  end

  def init(_) do
    children = [
      worker(LIRC.Producer, []),
      worker(LIRC.Process, []),
      worker(LIRC.AtomTableLoader, [], restart: :temporary)
    ]
    supervise(children, strategy: :one_for_one)
  end
end
