defmodule CEC.DeviceMenuControl do
  alias CEC.RemoteControlPassthrough
  alias CEC.Mapping.MenuRequest
  alias CEC.Mapping.MenuStatus

  def user_pressed(source, destination, button) do
    RemoteControlPassthrough.user_pressed(source, destination, button)
  end

  def user_released(source, destination) do
    RemoteControlPassthrough.user_released(source, destination)
  end

  def menu_response(source, destination, type) do
    CEC.send(source, destination, 0x8d, [MenuRequest.to_code(type)])
  end

  def menu_status(source, destination, state) do
    CEC.send(source, destination, 0x8e, [MenuStatus.to_code(state)])
  end
end
