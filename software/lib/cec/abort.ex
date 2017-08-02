defmodule CEC.Abort do
  alias CEC.Mapping.OpCodes

  def feature_abort(source, destination, opcode, reason) do
    CEC.send(source, destination, OpCodes.to_code(:feature_abort), [opcode, reason])
  end

  def abort(source, destination) do
    CEC.send(source, destination, OpCodes.to_code(:abort))
  end
end
