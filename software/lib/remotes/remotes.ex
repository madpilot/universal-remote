defmodule Remotes do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def init(:ok) do
    {:ok, %{:cec => CEC.Remote, :lirc => LIRC.Remote}}
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

  def handle_call({:register, name, module}, _from, state) do
    {:reply, {:ok}, state |> Map.merge(%{name => module})}
  end

  def handle_call({:deregister, name}, _from, state) do
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
       _ -> {:reply, {:error, :not_registered}, state}
    end
  end

  def handle_call({:list}, _from, state) do
    {:reply, state, state}
  end
end
