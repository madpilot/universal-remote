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
    Process.send_command(device, key)
  end

  def start_send(device, key) do
    Process.start_send(device, key)
  end

  def stop_send(device, key) do
    Process.stop_send(device, key)
  end
end
