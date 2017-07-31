defmodule CEC.OSDNameTransfer do
  def give_osd_name(source, destination) do
    CEC.send(source, destination, 0x46)
  end

  def set_osd_name(source, destination, name) do
    CEC.send(source, destination, 0x47, [name])
  end
end
