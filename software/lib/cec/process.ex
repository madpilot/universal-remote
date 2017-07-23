defmodule CEC.Process do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, [name: :cec])
  end

  def init(state) do
    import Supervisor.Spec

    {:ok, pid} = CEC.Producer.start_link
    port = Port.open({:spawn_executable, "/Users/myles/Projects/ir-blaster/software/spec/fake/cec-client"}, [:line, :binary])
    port |> Port.connect(pid)

    new_state = state |> Map.merge(%{port: port})
    {:ok, new_state}
  end

  def send_code(code) do
    GenServer.call(:cec, {:send_code, code})
  end

  def handle_call({:send_code, code}, _from, state) do
    state[:port] |> send({self(), {:command, "tx #{code}\n"}})
    {:reply, {:ok}, state}
  end
end
