defmodule CEC.DevicePowerStatus do
  alias CEC.Mapping.OpCodes

  def give_device_power_status(source, destination) do
    CEC.send(source, destination, OpCodes.to_code(:give_device_power_status))
  end

  def report_power_status(source, destination) do
    CEC.send(source, destination, OpCodes.to_code(:report_power_status))
  end
end
