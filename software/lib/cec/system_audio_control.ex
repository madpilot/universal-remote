defmodule CEC.SystemAudioControl do
  alias CEC.RemoteControlPassthrough
  alias CEC.Mapping.AudioStatus

  def give_audio_status(source, destination) do
    CEC.send(source, destination, 0x71)
  end

  def give_system_audio_mode_status(source, destination) do
    CEC.send(source, destination, 0x7D)
  end

  def report_audio_state(source, destination, muted, volume) do
    case muted do
      true -> CEC.send(source, destination, 0x7A, [128 + volume])
      false -> CEC.send(source, destination, 0x7A, [volume])
    end
  end

  def set_system_audio_mode(source, destination, status) do
    CEC.send(source, destination, 0x72, [AudioStatus.to_code(status)])
  end

  def system_audio_mode_request(source, destination, address) do
    CEC.send(source, destination, 0x70, [address])
  end

  def system_audio_mode_status(source, destination, status) do
    CEC.send(source, destination, 0x7E, [AudioStatus.to_code(status)])
  end

  def user_pressed(source, destination, button) do
    RemoteControlPassthrough.user_pressed(source, destination, button)
  end

  def user_released(source, destination) do
    RemoteControlPassthrough.user_released(source, destination)
  end
end
