defmodule CEC.Process do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, [name: __MODULE__])
  end

  def init(state) do
    port = Port.open({:spawn_executable, "/Users/myles/Projects/ir-blaster/software/spec/fake/cec-client"}, [:line, :binary])
    {:ok, state |> Map.merge(%{port: port})}
  end

  def handle_info({_, {:data, {:eol, line}}}, state) do
    GenServer.cast(CEC.Producer, {:cec, line})
    {:noreply, state}
  end

  def handle_call({:send_code, code}, _from, state) do
    state[:port]
    |> send({self(), {:command, "tx #{code}\n"}})
    {:reply, {:ok}, state}
  end

  def send_code(code) do
    GenServer.call(CEC.Process, {:send_code, code})
  end
end
