defmodule CEC.Process do
  use GenServer
  require Logger

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, [name: __MODULE__])
  end

  def init(state) do
    [executable: executable] = Application.get_env(:universal_remote, CEC.Process)
    Logger.info "Starting cec-client"
    Logger.debug "cec-client: #{executable}"
    port = Port.open({:spawn_executable, executable}, [:line, :binary])
    {:ok, state |> Map.merge(%{port: port})}
  end

  def handle_info({_, {:data, {:eol, line}}}, state) do
    GenServer.cast(CEC.Producer, {:cec, line})
    {:noreply, state}
  end

  def handle_call({:send_code, code}, _from, state) do
    Logger.debug "CEC - Sending #{code}"
    state[:port]
    |> send({self(), {:command, "tx #{code}\n"}})
    {:reply, {:ok}, state}
  end

  def send_code(code) do
    GenServer.call(CEC.Process, {:send_code, code})
  end

  def terminate(_reason, state) do
    Logger.debug "Killing cec-client"
    # Do this better...
    {:os_pid, pid} = Port.info(state[:port], :os_pid)
    Port.close(state[:port])
    System.cmd("kill", [pid])
  end
end
