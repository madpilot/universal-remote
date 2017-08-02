defmodule CEC.SystemAudioControl do
  alias CEC.Mapping.OpCodes
  alias CEC.RemoteControlPassthrough
  alias CEC.Mapping.AudioStatus

  def give_audio_status(source, destination) do
    CEC.send(source, destination, OpCodes.to_code(:give_audio_status))
  end

  def give_system_audio_mode_status(source, destination) do
    CEC.send(source, destination, OpCodes.to_code(:give_system_audio_mode_status))
  end

  def report_audio_state(source, destination, muted, volume) do
    case muted do
      true -> CEC.send(source, destination, OpCodes.to_code(:report_audio_state), [128 + volume])
      false -> CEC.send(source, destination, OpCodes.to_code(:report_audio_state), [volume])
    end
  end

  def set_system_audio_mode(source, destination, status) do
    CEC.send(source, destination, OpCodes.to_code(:set_system_audio_mode), [AudioStatus.to_code(status)])
  end

  def system_audio_mode_request(source, destination, address) do
    CEC.send(source, destination, OpCodes.to_code(:system_audio_mode_request), [address])
  end

  def system_audio_mode_status(source, destination, status) do
    CEC.send(source, destination, OpCodes.to_code(:system_audio_mode_status), [AudioStatus.to_code(status)])
  end

  def user_pressed(source, destination, button) do
    RemoteControlPassthrough.user_pressed(source, destination, button)
  end

  def user_released(source, destination) do
    RemoteControlPassthrough.user_released(source, destination)
  end
end
