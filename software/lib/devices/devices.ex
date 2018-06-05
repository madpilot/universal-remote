 defmodule Devices do
  use GenServer
  require Logger

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, [name: __MODULE__])
  end

  def init(initial) do
    {:ok, initial
      |> Enum.map(fn({name, file}) ->
        case Code.load_file(file) do
          [{module, _}] -> %{name => module}
        end
      end)
      |> Enum.reduce(%{}, fn(item, acc) -> Map.merge(acc, item) end)}
  end

  def register(name, module) do
    GenServer.call(__MODULE__, {:register, name, module})
  end

  def deregister(name) do
    GenServer.call(__MODULE__, {:deregister, name})
  end

  def registered(name) do
    GenServer.call(__MODULE__, {:registered, name})
  end

  def get(name) do
    GenServer.call(__MODULE__, {:get, name})
  end

  def list do
    GenServer.call(__MODULE__, {:list})
  end

  def send_once(name, command) do
    GenServer.call(__MODULE__, {:send_once, name, command})
  end

  def send_start(name, command) do
    GenServer.call(__MODULE__, {:send_start, name, command})
  end

  def send_stop(name, command) do
    GenServer.call(__MODULE__, {:send_stop, name, command})
  end

  def get_status(name, status) do
    GenServer.call(__MODULE__, {:get_status, name, status})
  end

  def handle_call({:register, name, module}, _from, state) do
    Logger.info "Devices - Registering #{inspect module} as #{name}"
    {:reply, {:ok}, state |> Map.merge(%{name => module})}
  end

  def handle_call({:deregister, name}, _from, state) do
    Logger.info "Devices - Deregistering #{name}"
    {:reply, {:ok}, state |> Map.delete(name)}
  end

  def handle_call({:registered, name}, _from, state) do
    case state do
      %{^name => _module} -> {:reply, true, state}
      _ -> {:reply, false, state}
    end
  end

  def handle_call({:get, name}, _from, state) do
    case state do
       %{^name => module} -> {:reply, {:ok, module}, state}
       _ -> {:reply, {:unknown_device}, state}
    end
  end

  def handle_call({:list}, _from, state) do
    {:reply, state, state}
  end

  defp handle_command({type, name, command}, _from, state) do
    case state do
      %{^name => module} -> (
        case module.commands |> Enum.any?(fn(k) -> k == command end) do
          true -> {:reply, apply(module, command, [type]), state}
          false -> {:reply, {:unknown_command}, state}
        end
      )
      _ -> {:reply, {:unknown_device}, state}
    end
  end

  def handle_call({:send_once, name, command}, from, state) do
    handle_command({:send_once, name, command}, from, state)
  end

  def handle_call({:send_start, name, command}, from, state) do
    handle_command({:send_start, name, command}, from, state)
  end

  def handle_call({:send_stop, name, command}, from, state) do
    handle_command({:send_stop, name, command}, from, state)
  end

  def handle_call({:get_status, name, status}, _from, state) do
    case state do
      %{^name => module} -> (
        case module.statuses |> Enum.any?(fn(k) -> k == status end) do
          true -> {:reply, apply(module, :get_status, [status]), state}
          false -> {:reply, {:unknown_status}, state}
        end
      )
      _ -> {:reply, {:unknown_device}, state}
    end
  end
end
