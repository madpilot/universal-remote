defmodule CEC.Remote do
  @behaviour UniversalRemote.Remotes.Behaviour

  alias CEC.Mapping.{Destination, ControlCodes}
  alias CEC.RemoteControlPassthrough

  defp valid_device(device) do
    Destination.devices
    |> keys()
    |> Enum.any?(fn(d) -> d == device end)
  end

  defp valid_key(key) do
    ControlCodes.controls
    |> keys()
    |> Enum.any?(fn(k) -> k == key end)
  end

  defp keys(list) do
    list
    |> Enum.map(fn(k) ->
      k |> elem(0)
    end)
  end

  def devices do
    {:ok, Destination.devices |> keys}
  end

  def commands(device) do
    case valid_device(device) do
      true -> {:ok, ControlCodes.controls |> keys}
      false -> {:error, :not_a_device}
    end
  end

  def send_once(device, key) do
    case valid_device(device) do
      true -> case valid_key(key) do
        true -> (
          RemoteControlPassthrough.user_pressed(:unregistered, device, key)
          {:ok}
        )
        false -> {:error, :not_a_key}
      end
      false -> {:error, :not_a_device}
    end
  end

  def send_start(device, key) do
    case valid_device(device) do
      true -> case valid_key(key) do
        true -> (
          RemoteControlPassthrough.user_pressed(:unregistered, device, key)
          {:ok}
        )
        false -> {:error, :not_a_key}
      end
      false -> {:error, :not_a_device}
    end
  end

  def send_stop(device, key) do
    case valid_device(device) do
      true -> case valid_key(key) do
        true -> (
          RemoteControlPassthrough.user_released(:unregistered, device)
          {:ok}
        )
        false -> {:error, :not_a_key}
      end
      false -> {:error, :not_a_device}
    end
  end
end
