defmodule CEC.Supervisor do
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, %{}, [name: __MODULE__])
  end

  def init(state) do
    children = [
      worker(CEC.Producer, []),
      worker(CEC.Consumer, []),
      worker(CEC.Process, [])
    ]
    supervise(children, strategy: :one_for_one)
  end
end
