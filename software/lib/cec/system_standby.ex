defmodule CEC.SystemStandby do
  alias CEC.Mapping.OpCodes

  def standby(source, destination \\ :broadcast) do
    CEC.send(source, destination, OpCodes.to_code(:standby))
  end
end
