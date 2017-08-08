defmodule LIRC.Process do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, [name: __MODULE__])
  end

  def init(state) do
    [irsend: irsend, irw: irw] = Application.get_env(:universal_remote, LIRC.Process)
    port = Port.open({:spawn_executable, irw}, [:line, :binary])
    {:ok, state |> Map.merge(%{port: port, irsend: irsend})}
  end

  def handle_info({_, {:data, {:eol, line}}}, state) do
    GenServer.cast(LIRC.Producer, {:lirc, line})
    {:noreply, state}
  end

  def handle_call({:send_code, device, key}, _from, state) do
    System.cmd(state[:irsend], ["send_once", device, key])
    {:reply, {:ok}, state}
  end

  def send_code(device, key) do
    GenServer.call(LIRC.Process, {:send_code, device |> Atom.to_string, key |> Atom.to_string |> String.upcase})
  end
end
