defmodule Devices do
  use GenServer
  require Logger

  def start_link(initial = %{}) do
    GenServer.start_link(__MODULE__, initial, [name: __MODULE__])
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

  def send(name, command) do
    GenServer.call(__MODULE__, {:send, name, command})
  end

  def handle_call({:register, name, module}, _from, state) do
    Logger.info "Remotes - Registering #{inspect module} as #{name}"
    {:reply, {:ok}, state |> Map.merge(%{name => module})}
  end

  def handle_call({:deregister, name}, _from, state) do
    Logger.info "Remotes - Deregistering #{name}"
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

  def handle_call({:send, name, command}, _from, state) do
    case state do
      %{^name => module} -> (
        case module.commands |> Enum.any?(fn(k) -> k == command end) do
          true -> {:reply, apply(module, command, []), state}
          false -> {:reply, {:unknown_command}, state}
        end
      )
      _ -> {:reply, {:unknown_device}, state}
    end
  end
end
