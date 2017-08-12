defmodule LIRC.Remote do
  @behaviour UniversalRemote.Remotes.Behaviour

  alias LIRC.Process

  def devices do
    Process.list_devices
  end

  def commands(device) do
    Process.list_commands(device)
  end

  def send_once(device, key) do
    Process.send_once(device, key)
  end

  def send_start(device, key) do
    Process.send_start(device, key)
  end

  def send_stop(device, key) do
    Process.send_stop(device, key)
  end
end
