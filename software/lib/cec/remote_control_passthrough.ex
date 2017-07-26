defmodule CEC.RemoteControlPassthrough do
  alias CEC.Mapping.ControlCodes

  def user_pressed(source, destination, button) do
    CEC.send(source, destination, 0x44, [ControlCodes.to_code(button)])
  end

  def user_released(source, destination) do
    CEC.send(source, destination, 0x45)
  end
end
