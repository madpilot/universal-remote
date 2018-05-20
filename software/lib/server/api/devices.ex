defmodule API.Devices do
  def serve(%{action: :get_devices}) do
    {:reply, %{devices: Devices.list |> Map.keys}}
  end

  def serve(%{action: :get_metadata, device: device}) do
    with {:ok, module} <- Devices.get(device |> String.to_atom),
         list          <- %{commands: module.commands(), statuses: module.statuses, meta_data: module.meta_data}
    do
      {:reply, %{device: device} |> Map.merge(list)}
    else
      message -> message
    end
  end

  def serve(%{action: :send_command, device: device, command: command}) do
    with :ok <- Devices.send_once(device |> String.to_atom, command |> String.to_atom) |> elem(0)
    do
      {:ok}
    else
      message -> message
    end
  end

  def serve(%{action: :start_command, device: device, command: command}) do
    with :ok <- Devices.send_start(device |> String.to_atom, command |> String.to_atom) |> elem(0)
    do
      {:ok}
    else
      message -> message
    end
  end

  def serve(%{action: :stop_command, device: device, command: command}) do
    with :ok <- Devices.send_stop(device |> String.to_atom, command |> String.to_atom) |> elem(0)
    do
      {:ok}
    else
      message -> message
    end
  end

  def serve(%{action: :list_statuses, device: device}) do
    with {:ok, module} <- Devices.get(device |> String.to_atom),
         list          <- module.statuses()
    do
      {:reply, %{statuses: list}}
    else
      message -> message
    end
  end

  def serve(%{action: :get_status, device: device, status: status}) do
    with {:ok, status} <- Devices.get_status(device |> String.to_atom, status |> String.to_atom)
    do
      {:reply, %{status: status, device: device}}
    else
      message -> message
    end
  end

  def serve(payload) do
    {:reply, %{error: "Unknown action: #{payload[:action]}"}}
  end
end
