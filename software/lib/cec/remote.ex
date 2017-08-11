defmodule CEC.Remote do
  @behaviour UniversalRemote.Remote
  alias CEC.Mapping.{Destination, ControlCodes}
  alias CEC.RemoteControlPassthrough

  # use Remote
  def devices do
    {:ok, Destination.devices
    |> Enum.map(fn(k) ->
      k
      |> elem(0)
    end)}
  end

  def commands(_) do
    {:ok, ControlCodes.controls
    |> Enum.map(fn(k) ->
      k |> elem(0)
    end)}
  end

  def send_once(device, key) do
    RemoteControlPassthrough.user_pressed(:unregistered, device, key)
    {:ok}
  end

  def start_send(device, key) do
    RemoteControlPassthrough.user_pressed(:unregistered, device, key)
    {:ok}
  end

  def stop_send(device, _) do
    RemoteControlPassthrough.user_released(:unregistered, device)
    {:ok}
  end
end
