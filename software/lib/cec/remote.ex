defmodule CEC.Remote do
  @behaviour UniversalRemote.Remotes.Behaviour

  alias CEC.Mapping.{Destination, ControlCodes}
  alias CEC.RemoteControlPassthrough

  def devices do
    {:ok, Destination.devices
    |> Enum.map(fn(k) ->
      k
      |> elem(0)
    end)}
  end

  def commands(_device) do
    {:ok, ControlCodes.controls
    |> Enum.map(fn(k) ->
      k |> elem(0)
    end)}
  end

  def send_once(device, key) do
    RemoteControlPassthrough.user_pressed(:unregistered, device, key)
    {:ok}
  end

  def send_start(device, key) do
    RemoteControlPassthrough.user_pressed(:unregistered, device, key)
    {:ok}
  end

  def send_stop(device, _) do
    RemoteControlPassthrough.user_released(:unregistered, device)
    {:ok}
  end
end
