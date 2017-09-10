defmodule TestDevice do
  use Device

  command :key_power_on do
    send_start do: {:ok, :send_start}
    send_stop do: {:ok, :send_stop}
    send_once do: {:ok, :send_once}
  end

  command :key_power_off do
    send_once do: {:ok, :send_once}
  end

  command :key_standby do
    send_start do: {:ok, :send_start}
  end

  passthrough [
    :key_volumeup
  ], to: TestDevice2

  passthrough [
    :key_volumedown
  ], to: Remotes.CEC, device: :audio_system
end
