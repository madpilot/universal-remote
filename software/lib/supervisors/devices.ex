 defmodule Supervisors.Devices do
  def start_link() do
    Supervisor.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def init(:ok) do
    {:ok, devices_paths} = Application.fetch_env(:universal_remote, :devices_paths)
    {:ok, autoload_devices} = Application.fetch_env(:universal_remote, :autoload_devices)

    children = [
      %{id: Devices, start: {Devices, :start_link, []}, restart: :permanent, type: :worker},
      %{id: Devices.Loader, start: {Devices.Loader, :start_link, [devices_paths]}, restart: :permanent, type: :worker},
      %{id: Devices.State, start: {Devices.State, :start_link, []}, restart: :permanent, type: :supervisor}
    ]

    children = case autoload_devices do
      true -> [%{id: Devices.Filewatcher, start: {Devices.Filewatcher, :start_link, [devices_paths]}, restart: :permanent, type: :supervisor} | children]
      false -> children
    end

    Supervisor.init(children, strategy: :one_for_one)
  end
end
