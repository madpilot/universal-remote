defmodule Devices.State do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:set_state, module, key, value}, state) do
    device_state = case state |> Map.get(module) do
      nil -> %{}
      module -> module
    end

    new_device_state = device_state |> Map.put(key, value)
    
    Event.Producer.broadcast(%{bus: :event, command: :state_change, device: module |> Macro.underscore |> String.to_atom, key: key, value: value})
    
    {:noreply, state |> Map.put(module, new_device_state)}
  end

  def handle_call({:get_state, module, key}, _from, state) do
    device_state = case state |> Map.get(module) do
      nil -> %{}
      module -> module
    end
    {:reply, device_state[key], state}
  end

  def set_state(module, key, value) do
    GenServer.cast(__MODULE__, {:set_state, module, key, value})
  end

  def get_state(module, key) do
    GenServer.call(__MODULE__, {:get_state, module, key})
  end
end
