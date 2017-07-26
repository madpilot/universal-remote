defmodule CEC.SystemStandby do
  def standby(source, destination \\ :broadcast) do
    CEC.send(source, destination, 0x36)
  end
end
