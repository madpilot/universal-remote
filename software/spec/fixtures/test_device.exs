defmodule TestDevice do
  use Device

  command :key_power_on do
    on_send_start do: {:ok, :send_start}
    on_send_stop do: {:ok, :send_stop}
    on_send_once do: {:ok, :send_once}
  end

  command :key_power_off do
    on_send_once do: {:ok, :send_once}
  end

  command :key_standby do
    on_send_start do: {:ok, :send_start}
  end

  passthrough [
    :key_volumeup
  ], to: TestDevice2

  passthrough [
    :key_volumedown
  ], to: CEC.Remote, device: :audio_system
end
