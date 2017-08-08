defmodule LIRC.Supervisor do
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, %{}, [name: __MODULE__])
  end

  def init(state) do
    children = [
      worker(LIRC.Producer, []),
      worker(LIRC.Consumer, []),
      worker(LIRC.Process, [])
    ]
    supervise(children, strategy: :one_for_one)
  end
end
