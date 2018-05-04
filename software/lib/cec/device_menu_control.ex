defmodule CEC.DeviceMenuControl do
  alias CEC.Mapping.OpCodes
  alias CEC.RemoteControlPassthrough
  alias CEC.Mapping.MenuRequest
  alias CEC.Mapping.MenuStatus

  def user_pressed(source, destination, button) do
    RemoteControlPassthrough.user_pressed(source, destination, button)
  end

  def user_released(source, destination) do
    RemoteControlPassthrough.user_released(source, destination)
  end

  def menu_request(source, destination, type) do
    CEC.send(source, destination, OpCodes.to_code(:menu_request), [MenuRequest.to_code(type)])
  end

  def menu_status(source, destination, state) do
    CEC.send(source, destination, OpCodes.to_code(:menu_status), [MenuStatus.to_code(state)])
  end
end
