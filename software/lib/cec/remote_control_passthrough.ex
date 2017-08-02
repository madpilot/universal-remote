defmodule CEC.RemoteControlPassthrough do
  alias CEC.Mapping.OpCodes
  alias CEC.Mapping.ControlCodes

  def user_pressed(source, destination, button) do
    CEC.send(source, destination, OpCodes.to_code(:user_pressed), [ControlCodes.to_code(button)])
  end

  def user_released(source, destination) do
    CEC.send(source, destination, OpCodes.to_code(:user_released))
  end
end
