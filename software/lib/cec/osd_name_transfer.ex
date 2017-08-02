defmodule CEC.OSDNameTransfer do
  alias CEC.Mapping.OpCodes

  def give_osd_name(source, destination) do
    CEC.send(source, destination,  OpCodes.to_code(:give_osd_name))
  end

  def set_osd_name(source, destination, name) do
    CEC.send(source, destination,  OpCodes.to_code(:set_osd_name), [name])
  end
end
