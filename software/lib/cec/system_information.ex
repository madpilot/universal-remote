defmodule CEC.SystemInformation do
  alias CEC.Mapping.{Versions,Devices}

  def cec_version(source, destination, version) do
    CEC.send(source, destination, 0x9e, [Versions.to_code(version)])
  end

  def get_cec_version(source, destination) do
    CEC.send(source, destination, 0x9f)
  end

  def get_menu_language(source, destination) do
    CEC.send(source, destination, 0x91)
  end

  def give_physical_address(source, destination) do
    CEC.send(source, destination, 0x83)
  end

  def polling_message(source, destination) do
    CEC.send(source, destination)
  end

  def report_phsyical_address(source, destination, address, type) do
    CEC.send(source, destination, 0x84, [address, Devices.to_code(type)])
  end

  def set_menu_language(source, destination, language) do
    CEC.send(source, destination, 0x32, [language])
  end
end
