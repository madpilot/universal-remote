defmodule TestDevice2 do
  use Device

  command :key_volumeup do
    on_send_start do: {:ok, :start, :key_volumeup}
    on_send_stop do: {:ok, :stop, :key_volumeup}
    on_send_once do: {:ok, :once, :key_volumeup}
  end

  command :key_volumedown do
    on_send_start do: {:ok, :start, :key_volumedown}
  end
end
