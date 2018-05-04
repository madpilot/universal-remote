defmodule CEC.SystemInformation do
  alias CEC.Mapping.OpCodes
  alias CEC.Mapping.{Versions,Devices}

  def cec_version(source, destination, version) do
    CEC.send(source, destination, OpCodes.to_code(:cec_version), [Versions.to_code(version)])
  end

  def get_cec_version(source, destination) do
    CEC.send(source, destination, OpCodes.to_code(:get_cec_version))
  end

  def get_menu_language(source, destination) do
    CEC.send(source, destination, OpCodes.to_code(:get_menu_language))
  end

  def give_physical_address(source, destination) do
    CEC.send(source, destination, OpCodes.to_code(:give_physical_address))
  end

  def polling_message(source, destination) do
    CEC.send(source, destination)
  end

  def report_physical_address(source, destination, address, type) do
    CEC.send(source, destination, OpCodes.to_code(:report_physical_address), [address, Devices.to_code(type)])
  end

  def set_menu_language(source, destination, language) do
    CEC.send(source, destination, OpCodes.to_code(:set_menu_language), [language])
  end
end
